#' Check validity of a metadata statement
#' 
#' In the Darwin Core standard, metadata statements are mandatory and must be
#' provided in Ecological Meta Language (EML) in a file called `eml.xml`. This
#' function applies a series of checks designed by GBIF to check the structure
#' of the specified xml document for consistency with the standard. Note, 
#' however, that this function doesn't check the _content_ of those files,
#' meaning a file could be structurally sound and still be lacking critical 
#' information.
#' @param x Object of any class handled by `delma`; i.e. `character`, 
#' `tbl_df`, `list` or `xml_document`.
#' @param file Alternatively an EML file to check. If both `x` and `file` are 
#' supplied, `x` is chosen.
#' @details
#' This function uses local versions of `dc.xsd`, `eml-gbif-profile.xsd` and 
#' `eml.xsd` downloaded
#'  from \code{http://rs.gbif.org/schema/eml-gbif-profile/1.3/} on 
#'  2024-09-25.
#' @return Invisibly returns a tibble showing parsed errors; or an empty 
#' tibble if no errors are identified.
#' @examples \dontrun{
#' # check a file
#' check_eml(file = "https://collections.ala.org.au/ws/eml/dr368")
#' }
#' @importFrom rlang abort
#' @importFrom dplyr bind_rows
#' @importFrom xml2 read_xml
#' @importFrom xml2 xml_validate
#' @export
check_eml <- function(x,
                      file
                      ) {
  # check inputs
  if(!missing(x)){
    if(!inherits(x, "xml_document")){
      xmldoc <- as_eml_xml(x)
    }else{
      xmldoc <- x
    }
  }else{
    if(missing(file)){
      abort("both `x` and `file` are missing, with no default")
    }else{
      xmldoc <- read_xml(file)
    }
  }

  # look up schema doc
  schema_doc <- system.file("extdata", 
                            "eml-gbif-profile",
                            "1.3",
                            "eml-gbif-profile.xsd", 
                            package = "delma",
                            mustWork = TRUE)
  
  # run validation
  xml_validate(xmldoc, schema = schema_doc) |>
    validator_to_tibble() |>
    invisible()
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
      map(~ format_messages_from_checks(.x)) |>
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