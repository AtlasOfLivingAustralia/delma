#' Check validity of a metadata statement
#' 
#' In the Darwin Core standard, metadata statements are mandatory and must be
#' provided in Ecological Meta Language (EML) in a file called `eml.xml`. This
#' function applies a series of checks designed by GBIF to check the structure
#' of the specified xml document for consistency with the standard. Note, 
#' however, that this function doesn't check the _content_ of those files,
#' meaning a file could be structurally sound and still be lacking critical 
#' information.
#' @param x An object of class `xml_document` from xml2, or optionally a file.
#' @param schema Vector of strings selecting one or more schemas to check 
#' against.
#' @details
#' This function uses local versions of `dc.xsd`, `eml-gbif-profile.xsd` and 
#' `eml.xsd` downloaded
#'  from \link{http://rs.gbif.org/schema/eml-gbif-profile/1.3/} on 2024-09-25.
#' @return Invisibly returns a tibble showing parsed errors; or an empty 
#' tibble if no errors are identified.
#' @importFrom dplyr bind_rows
#' @importFrom xml2 read_xml
#' @importFrom xml2 xml_validate
#' @export
check_eml <- function(x, # TODO: support file names
                      schema = c("xml",
                                 "dc",
                                 "eml-2.2.0",
                                 "eml-gbif-profile-1.3")) {
  # check inputs
  x <- check_file_or_object(x)
  schema <- match.arg(schema, several.ok = TRUE)
  
  
  # check file using xml_validate
  result <- map(schema,
      \(a){
        validator_file <- switch_schemas(a) |>
          read_xml()
        xml_validate(x, 
                     schema = validator_file) |>
          validator_to_tibble()
      }) |>
    bind_rows() |>
    unique()

  # print validation errors
  # NOTE: this uses functions defined in `check_occurrences()`

  invisible(result)
}

#' Internal function to check whether object supplied is a file or an object
#' @importFrom glue glue
#' @importFrom rlang abort
#' @importFrom xml2 read_xml
#' @noRd
#' @keywords Internal
check_file_or_object <- function(x){
  if(inherits(x, "xml_document")){
    result <- x
  }else if(inherits(x, "character")){
    if(length(x) == 1){
      result <- read_xml(x)
    }else{
      result <- try(as_eml_xml(x))
    }
  }else{
    result <- try(as_eml_xml(x))
  }
  # return
  if(inherits(result, "try-error")){
    abort(glue("Unable to convert `{x}` to xml."))
  }else{
    result
  }
}

#' Internal function to select the file associated with a given schema
#' 
#' NOTE: we use `extdata` here because storing these files in `sysdata.rda`
#' breaks the connections between files, causing validation to fail.
#' @importFrom rlang abort
#' @noRd
#' @keywords Internal
switch_schemas <- function(string){
  switch(string,
         "xml" = system.file("extdata", 
                             "xml.xsd",
                             package = "elm",
                             mustWork = TRUE),
         "dc" = system.file("extdata", 
                            "dc.xsd", 
                            package = "elm",
                            mustWork = TRUE),
         "eml-2.2.0" = system.file("extdata", 
                                   "eml-2.2.0",
                                   "eml.xsd", 
                                   package = "elm",
                                   mustWork = TRUE),
         "eml-gbif-profile-1.3" = system.file("extdata", 
                                              "eml-gbif-profile",
                                              "1.3",
                                              "eml-gbif-profile.xsd", 
                                              package = "elm",
                                              mustWork = TRUE),
         abort("unknown schema")
      )
}

#' Internal function to get validator to return a tibble
#' @importFrom tibble tibble
#' @noRd
#' @keywords Internal
validator_to_tibble <- function(x){
  if(!x){
    attr(x, "errors") |>
      parse_validator_errors()
  }else{
    tibble(term = character(),
           messages = character(),
           remedy = character())
  }
}

#' Internal function to extract information from `xml_validate()` error strings
#' @importFrom dplyr bind_rows
#' @importFrom dplyr mutate
#' @importFrom purrr map
#' @importFrom stringr str_extract
#' @noRd
#' @keywords Internal
parse_validator_errors <- function(strings){
  # strings <- strings[!grepl("Skipping import of schema", x = strings)]
  element <- str_extract(strings, "^Element '[[:graph:]]+'") |>
    gsub("^Element '|'$", "", x = _)
  elements_list <- str_extract(strings, "':([[:graph:]]|\\s)+") |>
    sub("':\\s", "", x = _) |>
    strsplit("\\.\\s") 
  map(.x = elements_list,
      .f = \(x){
        if(length(x) < 2){
          x[[2]] <- ""
        }
        names(x) <- c("messages", "remedy")
        x
      }) |>
    bind_rows() |>
    mutate(term = element, .before = "messages")
}

#' Print outcomes from validation
#' @importFrom cli cli_h2
#' @importFrom purrr map
#' @noRd
#' @keywords Internal
print_xsd_messages <- function(df){
  if(nrow(df) > 0){
    cli_h2("Check result:")
    split(df, seq_len(nrow(df))) |>
      map(~ format_messages_from_checks(.x)) |> # NOTE: need to recreate this
      invisible()
  }else{
    cli_h2("No errors found!")
  }
}

#' Format each saved message from `check_all()` nicely
#' @importFrom cli cat_line
#' @importFrom cli cli_rule
#' @noRd
#' @keywords Internal
format_messages_from_checks <- function(df) {
  # retrieve term & message
  term <- df$term |> unique()
  m <- paste0(df$messages)
  
  # format & print
  cat_line()
  cli_rule("Error in {term}")
  cat_line()
  cat_line(m)
  cat_line()
}