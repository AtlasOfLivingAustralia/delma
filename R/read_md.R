#' Import a markdown file as text
#' 
#' Very basic function to create an object of class `md` (i.e. a `vector` of
#' class `character`).
#' @param file filename
#' @export
read_md <- function(file){
  x <- readLines(file)
  class(x) <- "md"
  x
}

#' @rdname read_md
#' @param x object of class `md`
#' @export
write_md <- function(x, file){
  writeLines(x, file)
}