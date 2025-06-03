#' Check validity of a metadata statement
#' 
#' In the Darwin Core standard, metadata statements are mandatory and must be
#' provided in Ecological Metadata Language (EML) in a file called `eml.xml`. This
#' function applies a series of checks designed by GBIF to check the structure
#' of the specified xml document for consistency with the standard. Note, 
#' however, that this function doesn't check the _content_ of those files,
#' meaning a file could be structurally sound and still be lacking critical 
#' information.
#' @param file An EML file to check Can be either local or a URL.
#' @param schema Either `NULL` (the default) to compare to the GBIF profile;
#' or a URL to a valid schema (passed internally to [xml2::read_xml]).
#' @param quiet (logical) Should messages be hidden? Defaults to `FALSE`.
#' @details
#' This function uses local versions of `dc.xsd`, `eml-gbif-profile.xsd` and 
#' `eml.xsd` downloaded
#'  from \code{http://rs.gbif.org/schema/eml-gbif-profile/1.3/} on 
#'  2024-09-25.
#' @return Invisibly returns a tibble showing parsed errors; or an empty 
#' tibble if no errors are identified.
#' @examples
#' source_file <- system.file("extdata", 
#'                            "bionet_metadata.xml",
#'                            package = "delma")
#' check_metadata(source_file)
#' @export
check_metadata <- function(file = NULL,
                           schema = NULL,
                           quiet = FALSE){
  # check inputs
  if(is.null(file)){
    cli::cli_abort("both `x` and `file` are missing, with no default")
  }else{
    xmldoc <- xml2::read_xml(file)
  }

  # look up schema doc
  if(is.null(schema)){
    schema_doc <- system.file("extdata", 
                              "eml-gbif-profile",
                              "1.3",
                              "eml-gbif-profile.xsd", 
                              package = "delma",
                              mustWork = TRUE)    
  }else{
    schema_doc <- schema
  }
  
  # run validation
  result <- xml2::xml_validate(xmldoc, 
                     # schema = xml2::read_xml("http://rs.gbif.org/schema/eml-gbif-profile/1.3/eml-gbif-profile.xsd")) # same outcome
                     schema = xml2::read_xml(schema_doc)) |>
    validator_to_tibble()
  
  if(!quiet){
    print_xsd_messages(result)
  }
  
  invisible(result)
}

#' Internal function to get validator to return a tibble
#' @noRd
#' @keywords Internal
validator_to_tibble <- function(x){
  if(!x){
    result <- attr(x, "errors") |>
      parse_validator_errors()
    if(result$title[1] == "Error in `import` from http://www.w3.org/2001/XMLSchema"){ # always appears for some reason
      result[-1, ]
    }else{
      result
    }
  }else{
    tibble::tibble(title = character(),
                   message = character())
  }
}

#' Internal function to extract information from `xml_validate()` error strings
#' @noRd
#' @keywords Internal
parse_validator_errors <- function(strings){
  # strings <- strings[!grepl("Skipping import of schema", x = strings)]
  element <- format_elements(strings)
  elements_list <- stringr::str_extract(strings, 
                                        "':([[:graph:]]|\\s)+") |>
    sub("':\\s", "", x = _)
  ## NOTE: Could add code here to pull out `expected` values into dot points
  ## using cli::cli_bullets()
  tibble::tibble(
    title = element,
    message = elements_list)
}

#' Internal function 
#' @noRd
#' @keywords Internal
format_elements <- function(strings){
  result <- stringr::str_extract(strings, 
                                 "^Element '[[:graph:]]+'") |>
    gsub("^Element '|'$", "", x = _)
  purrr::map(result, \(a){
    if(grepl("^\\{", a)){
      term <- a |>
        stringr::str_extract("\\}[:graph:]+$") |>
        stringr::str_remove("^\\}") 
      term_url <- a |>
        stringr::str_remove("^\\{") |>
        stringr::str_remove("\\}[:graph:]+$")
      glue::glue("Error in `{term}` from {term_url}")
    }else{
      glue::glue("Error in `{a}`")
    }
  }) |>
    as.character()
}

#' Print outcomes from validation
#' @noRd
#' @keywords Internal
print_xsd_messages <- function(df){
  cli::cli_h2("`check_metadata()` result:")
  if(nrow(df) > 0){
    split(df, seq_len(nrow(df))) |>
      purrr::map(~ format_messages_from_checks(.x)) |>
      invisible()
  }else{
    cli::cli_text("No errors found!")
  }
}

#' Format each saved message from `check_all()` nicely
#' @noRd
#' @keywords Internal
format_messages_from_checks <- function(df) {
  title <- df$title |> 
    unique() |>
    make_glue_safe()
  m <- df$message |> 
    make_glue_safe()
  cli::cli_h3(title)
  cli::cli_text(m)
  cli::cat_line()
}

#' Prevent curly brackets in messages
#' Source bug was this string:
#' "The QName value '{http://www.w3.org/XML/1998/namespace}lang' does not resolve to a(n) attribute declaration"
#' @noRd
#' @keywords Internal
make_glue_safe <- function(x){
  x |>
    gsub("\\{", "<", x = _) |>
    gsub("\\}", ">", x = _)
}