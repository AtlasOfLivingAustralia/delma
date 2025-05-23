#' Read an EML-formatted metadata document
#' 
#' `read_eml()` imports metadata from an EML file into the workspace as a 
#' `tibble`.
#' @param file Filename or URL to read from.
#' @returns `read_eml()` returns an object of class `tbl_df`, `tbl` and 
#' `data.frame` (i.e. a `tibble`).
#' @examples
#' source_file <- system.file("extdata", 
#'                            "bionet_metadata.xml",
#'                            package = "delma")
#' df <- read_eml(source_file)
#' @export
read_eml <- function(file){
  # abort if file missing
  if(missing(file)){
    cli::cli_abort("`file` is missing, with no default.")
  }
  # check file is correctly specified
  check_is_single_character(file)
  # check is either a url or ends in .xml
  if(!grepl("(https?|ftp)://[^ /$.?#].[^\\s]*", file)){ # is not a url
    # check valid suffix
    if(!grepl("\\.xml$", file)){
      cli::cli_abort("Argument `file` must end in the suffix `xml`")
    }
    # check file exists
    if(!file.exists(file)){
      cli::cli_abort("Specified `file` does not exist.")
    }
  }
  # import & convert to tibble
  xml2::read_xml(file) |> 
    as_eml_tibble()
}

#' Internal function to check for characters
#' @noRd
#' @keywords Internal
check_is_single_character <- function(x){
  if(!inherits(x, "character")){
    cli::cli_abort("Supplied object is not of type 'character'")
  }
  if(length(x) != 1L){
    cli::cli_abort(glue::glue("Object is of length {length(x)}, should be 1"))
  }
}