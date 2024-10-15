#' Write metadata to markdown
#' 
#' Write metadata from a `tibble`, `character`, `list` or `xml_document` to
#' a markdown (`.md`) document.
#' @param x Object of any class handled by `elm`; i.e. `character`, `tbl_df`,
#' `list` or `xml_document`.
#' @param file Filename to export to.
#' @importFrom rlang abort
#' @importFrom xml2 write_xml
#' @export
write_md <- function(x, file){
  
  # check for correct format
  if(inherits(x, c("tbl_df", "list", "xml_document"))){
    x <- as_eml_chr(x)
  }
  
  # stop if not converted
  if(!inherits(x, "character")){
    abort(c("`write_md()` only accepts objects of class `character`.",
            i = "Use `as_eml_chr()` to convert it."))
  }
  
  # stop if file suffix is incorrect
  check_is_single_character(file)
  if(!grepl(".md$", file)){
    abort("`write_md()` only writes files with a `.md` suffix.")
  }
  
  writeLines(x, file)
}
