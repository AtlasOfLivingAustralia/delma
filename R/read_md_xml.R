#' Read or write metadata as `xml`
#' 
#' Import metadata to or from `xml`. Note that imports to a `tibble`,
#' but can export from all `elm` formats.
#' @name read_md_xml
#' @param file filename
#' @returns An object of class `md_tibble`.
#' as defined in `xml2`.
#' @importFrom rlang abort
#' @importFrom xml2 read_xml
#' @export
read_md_xml <- function(file){
  # check that a `file` argument is supplied
  if(missing(file)){
    abort("Argument `file` is missing, with no default.")
  }
  
  # check multiple files aren't given
  if(length(file) > 1){
    abort("Argument `file` must have length = 1")
  }
  
  # check is either a url or ends in .xml
  if(!grepl("(https?|ftp)://[^ /$.?#].[^\\s]*", file) &
     !grepl(".xml$", file)){
    abort("Argument `file` must either be a url, or a file name ending in `.xml`")
  }
  
  # import & convert
  read_xml(file) |>
    as_md_tibble()
}

#' @rdname read_md_xml
#' @importFrom rlang abort
#' @importFrom xml2 write_xml
#' @param x Object of any class handled by `elm`; i.e. `character`, `tbl_df`,
#' `list` or `xml_document`.
#' @export
write_md_xml <- function(x, file){
  
  # check for correct format
  if(inherits(x, c("character", "tbl_df", "list"))){
    x <- as_md_xml(x)
  }
  
  # stop if not converted
  if(!inherits(x, "xml_document")){
    abort(c("`write_md()` only accepts objects of class `xml_document`.",
            i = "Use `as_md_xml()` to convert it."))
  }else{
    class(x) <- "xml_document"
  }
  
  # stop if file suffix is incorrect
  if(!grepl(".xml$", file)){
    abort("`write_md_xml()` only writes files with a `.xml` suffix.")
  }
  
  write_xml(x, file)
}