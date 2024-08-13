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
  x <- readLines(file)
  class(x) <- "md_chr"
  as_md_tibble(x)
}

#' @rdname read_md_chr
#' @importFrom rlang abort
#' @param x Object of any class defined by `elm`; i.e. `md_chr`, `md_tibble`,
#' `md_list` or `md_xml`.
#' @export
write_md_chr <- function(x, file){
  
  # check for correct format
  if(inherits(x, c("md_tibble", "md_list", "md_xml"))){
    x <- as_md_chr(x)
  }
  
  # stop if not converted
  if(!inherits(x, "md_chr")){
    abort(c("`write_md()` only accepts objects of class `md_chr`.",
            i = "Use `as_md_chr()` to convert it."))
  }
  
  # stop if file suffix is incorrect
  if(!grepl(".md$", file)){
    abort("`write_md()` only writes files with a `.md` suffix.")
  }
  
  writeLines(x, file)
}