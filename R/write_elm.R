#' Write metadata to markdown or xml
#' 
#' Write metadata from a `tibble`, `character`, `list` or `xml_document` to
#' a markdown (`.md`) or xml (`.xml`) document.
#' @name write_elm
#' @param x Object of any class handled by `elm`; i.e. `character`, `tbl_df`,
#' `list` or `xml_document`.
#' @param file filename to save to
#' @importFrom rlang abort
#' @export
write_elm_chr <- function(x, file){
  
  # check for correct format
  if(inherits(x, c("tbl_df", "list", "xml_document"))){
    x <- as_elm_chr(x)
  }
  
  # stop if not converted
  if(!inherits(x, "character")){
    abort(c("`write_md()` only accepts objects of class `character`.",
            i = "Use `as_elm_chr()` to convert it."))
  }
  
  # stop if file suffix is incorrect
  if(!grepl(".md$", file)){
    abort("`write_md()` only writes files with a `.md` suffix.")
  }
  
  writeLines(x, file)
}

#' @rdname write_elm
#' @importFrom rlang abort
#' @importFrom xml2 write_xml
#' @export
write_elm_xml <- function(x, file){
  
  # check for correct format
  if(inherits(x, c("character", "tbl_df", "list"))){
    x <- as_elm_xml(x)
  }
  
  # stop if not converted
  if(!inherits(x, "xml_document")){
    abort(c("`write_md()` only accepts objects of class `xml_document`.",
            i = "Use `as_elm_xml()` to convert it."))
  }else{
    class(x) <- "xml_document"
  }
  
  # stop if file suffix is incorrect
  if(!grepl(".xml$", file)){
    abort("`write_elm_xml()` only writes files with a `.xml` suffix.")
  }
  
  write_xml(x, file)
}
