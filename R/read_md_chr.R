#' Handle metadata as markdown
#' 
#' Import metadata to or from a markdown file. Note that imports to a `tibble`,
#' but can export from all `elm` formats.
#' @name read_md_chr
#' @param file filename
#' @returns An object of class `md_tibble`.
#' @importFrom rlang abort
#' @export
read_md_chr <- function(file){
  if(missing(file)){
    abort("`file` is missing, with no default.")
  }
  if(!file.exists(file)){
    abort("Specified `file` does not exist.")
  }
  if(!grepl(".md$", file)){
    abort("`read_md_chr()` only reads files with a `.md` suffix.")
  }
  readLines(file) |> as_md_tibble()
}

#' @rdname read_md_chr
#' @importFrom rlang abort
#' @param x Object of any class handled by `elm`; i.e. `character`, `tbl_df`,
#' `list` or `xml_document`.
#' @export
write_md_chr <- function(x, file){
  
  # check for correct format
  if(inherits(x, c("tbl_df", "list", "xml_document"))){
    x <- as_md_chr(x)
  }
  
  # stop if not converted
  if(!inherits(x, "character")){
    abort(c("`write_md()` only accepts objects of class `character`.",
            i = "Use `as_md_chr()` to convert it."))
  }
  
  # stop if file suffix is incorrect
  if(!grepl(".md$", file)){
    abort("`write_md()` only writes files with a `.md` suffix.")
  }
  
  writeLines(x, file)
}