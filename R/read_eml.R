#' Read or write EML-formatted metadata
#' 
#' `read_eml()` imports metadata from an EML file into the workspace as a 
#' `tibble`. `write_eml()` write a `string`, `tibble`, `list` or `xml_document` 
#' to an EML file. Note that EML files always have the file extension `.xml`.
#' @param file Filename to read from or write to. In the case of `read_eml()`,
#' can alternatively be a url to a valid EML document. 
#' @returns `read_eml()` returns an object of class `tbl_df`, `tbl` and 
#' `data.frame` (i.e. a `tibble`). `write_eml()` doesn't return anything, and
#' is called for the side-effect of writing the specified EML file to disk
#' @examples \dontrun{
#' # read from a url
#' df <- read_eml("https://collections.ala.org.au/ws/eml/dr368")
#' 
#' # write to disk
#' write_eml(df, "example.xml")
#' }
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

#' @rdname read_eml
#' @param x Object of any class handled by `paperbark`; i.e. `character`, 
#' `tbl_df`, `list` or `xml_document`.
#' @importFrom rlang abort
#' @importFrom xml2 write_xml
#' @export
write_eml <- function(x, 
                      file){
  # check for correct format
  if(inherits(x, c("character", "tbl_df", "list"))){
    x <- as_eml_xml(x)
  }
  
  # stop if not converted
  if(!inherits(x, "xml_document")){
    abort(c("`write_eml()` only accepts objects of class `xml_document`.",
            i = "Use `as_eml_xml()` to convert it."))
  }else{
    class(x) <- "xml_document"
  }
  
  # stop if file suffix is incorrect
  check_is_single_character(file)
  if(!grepl(".xml$", file)){
    abort("`write_eml()` only writes files with a `.xml` suffix.")
  }
  
  write_xml(x, file)
}
