#' Write metadata to markdown or xml
#' 
#' Write metadata from a `tibble`, `character`, `list` or `xml_document` to
#' a markdown (`.md`) or xml (`.xml`) document.
#' @name write_elm
#' @param x Object of any class handled by `elm`; i.e. `character`, `tbl_df`,
#' `list` or `xml_document`.
#' @param file Filename to export to.
#' @param format What format should the data be written to? Should be either 
#' `"md"` (for markdown) or `"xml"`. If missing (the default), the function will 
#' guess based on the `file` suffix.
#' @importFrom rlang abort
#' @export
write_elm <- function(x, 
                      file,
                      format){
  # check format, but only if supplied
  if(!missing(format)){
    check_is_single_character(format)
    switch(format, 
           "xml" = write_elm_xml(x, file),
           "md" = write_elm_md(x, file),
           {bullets <- c(glue("Specified `format` not recognized (\"{format}\")"),
                         i = "valid values are \"md\" or \"xml\"")
           abort(bullets)}
    )
    # otherwise auto-detect file type
  }else{
    file_suffix <- str_extract(file, "\\.[:alpha:]+$")
    switch(file_suffix, 
           ".md" = write_elm_md(x, file),
           ".xml" = write_elm_xml(x, file),
           {bullets <- c(glue("Specified `file` suffix not recognized (\"{file_suffix}\")"),
                         i = "valid file extensions are \".md\" or \".xml\"")
           abort(bullets)})
  }
}

#' @rdname write_elm
#' @importFrom rlang abort
#' @export
write_elm_md <- function(x, file){
  
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
  check_is_single_character(file)
  if(!grepl(".md$", file)){
    abort("`write_elm()` only writes files with a `.md` suffix.")
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
    abort(c("`write_elm()` only accepts objects of class `xml_document`.",
            i = "Use `as_elm_xml()` to convert it."))
  }else{
    class(x) <- "xml_document"
  }
  
  # stop if file suffix is incorrect
  check_is_single_character(file)
  if(!grepl(".xml$", file)){
    abort("`write_elm_xml()` only writes files with a `.xml` suffix.")
  }
  
  write_xml(x, file)
}
