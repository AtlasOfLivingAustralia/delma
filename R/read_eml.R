#' Read an EML-formatted metadata document
#' 
#' `read_eml()` imports metadata from an EML file into the workspace as a 
#' `tibble`.
#' @param file Filename or URL to read from.
#' @returns `read_eml()` returns an object of class `tbl_df`, `tbl` and 
#' `data.frame` (i.e. a `tibble`).
#' @examples \dontrun{
#' # read from a url
#' df <- read_eml("https://collections.ala.org.au/ws/eml/dr368")
#' }
#' @export
read_eml <- function(file){
  # abort if file missing
  if(missing(file)){
    rlang::abort("`file` is missing, with no default.")
  }
  # check file is correctly specified
  check_is_single_character(file)
  # check is either a url or ends in .xml
  if(!grepl("(https?|ftp)://[^ /$.?#].[^\\s]*", file)){ # is not a url
    # check valid suffix
    if(!grepl("\\.xml$", file)){
      rlang::abort("Argument `file` must end in the suffix `xml`")
    }
    # check file exists
    if(!file.exists(file)){
      rlang::abort("Specified `file` does not exist.")
    }
  }
  # import & convert to tibble
  xml2::read_xml(file) |> 
    as_eml_tbl()
}

#' Internal function to check for characters
#' @noRd
#' @keywords Internal
check_is_single_character <- function(x){
  if(!inherits(x, "character")){
    rlang::abort("Supplied object is not of type 'character'")
  }
  if(length(x) != 1L){
    rlang::abort(glue::glue("Object is of length {length(x)}, should be 1"))
  }
}