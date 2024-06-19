#' Import a markdown file as text
#' 
#' Very basic function to create an object of class `md` (i.e. a `vector` of
#' class `character`).
#' @param file filename
#' @importFrom rlang abort
#' @export
read_md <- function(file){
  if(missing(file)){
    abort("`file` is missing, with no default.")
  }
  if(!file.exists(file)){
    abort("Specified `file` does not exist.")
  }
  if(!grepl(".md$", file)){
    abort("`read_md()` only reads files with a `.md` suffix.")
  }
  x <- readLines(file)
  class(x) <- "md"
  x
}

#' @rdname read_md
#' @importFrom rlang abort
#' @param x object of class `md`
#' @export
write_md <- function(x, file){
  if(!inherits(x, "md")){
    abort(c("`write_md()` only accepts objects of class `md`.",
            i = "Use `as_md()` to convert it."))
  }
  if(!grepl(".md$", file)){
    abort("`write_md()` only writes files with a `.md` suffix.")
  }
  writeLines(x, file)
}