#' Read or write metadata as `xml`
#' 
#' Import metadata to or from `xml`.  Note that imports to a `tibble`,
#' but can export from all `elm` formats.
#' @name read_md_xml
#' @param file filename
#' @returns An object of class `md_tibble`.
#' as defined in `xml2`.
#' @importFrom rlang abort
#' @importFrom xml2 read_xml
#' @export
read_md_xml <- function(file){
  if(missing(file)){
    abort("`file` is missing, with no default.")
  }
  x <- read_xml(file)
  class(x) <- c("md_xml", "xml_document", "xml_node")
  as_md_tibble(x)
}

#' @rdname read_md_xml
#' @importFrom rlang abort
#' @importFrom xml2 write_xml
#' @param x Object of any class defined by `elm`; i.e. `md_chr`, `md_tibble`,
#' `md_list` or `md_xml`.
#' @export
write_md_xml <- function(x, file){
  
  # check for correct format
  if(inherits(x, c("md_chr", "md_tibble", "md_list"))){
    x <- as_md_xml(x)
  }
  
  # stop if not converted
  if(!inherits(x, "md_xml")){
    abort(c("`write_md()` only accepts objects of class `md_xml`.",
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