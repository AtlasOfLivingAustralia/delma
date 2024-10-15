#' Read metadata from xml
#' 
#' Import metadata from an xml file locally or online. 
#' @param file Filename or url 
#' @returns An object of class `tbl_df`, `tbl` and `data.frame` (i.e. a `tibble`).
#' @importFrom rlang abort
#' @importFrom xml2 read_xml
#' @export
read_eml <- function(file){
  # abort if file missing
  if(missing(file)){
    abort("`file` is missing, with no default.")
  }
  # check file is correctly specified
  check_is_single_character(file)
  # check is either a url or ends in .xml
  if(!grepl("(https?|ftp)://[^ /$.?#].[^\\s]*", file)){ # is not a url
    # check valid suffix
    if(!grepl("\\.xml$", file)){
      abort("Argument `file` must end in the suffix `xml`")
    }
    # check file exists
    if(!file.exists(file)){
      abort("Specified `file` does not exist.")
    }
  }
  # import & convert to tibble
  read_xml(file) |> as_eml_tibble()
}

#' Internal function to check for characters
#' @importFrom glue glue
#' @importFrom rlang abort
#' @noRd
#' @keywords Internal
check_is_single_character <- function(x){
  if(!inherits(x, "character")){
    abort("Supplied object is not of type 'character'")
  }
  if(length(x) != 1L){
    abort(glue("Object is of length {length(x)}, should be 1"))
  }
}
