#' Write metadata to xml
#' 
#' Write metadata from a `tibble`, `character`, `list` or `xml_document` to
#' an xml (`.xml`) document.
#' @param x Object of any class handled by `elm`; i.e. `character`, `tbl_df`,
#' `list` or `xml_document`.
#' @param file Filename to export to.
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
      abort(c("`write_elm()` only accepts objects of class `xml_document`.",
              i = "Use `as_elm_xml()` to convert it."))
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