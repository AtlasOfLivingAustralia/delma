#' Convert metadata to class `md`
#' 
#' This is basically a vector
#' @name as_md
#' @param x Object to be converted
#' @param ... other arguments, currently ignored
#' @export
as_md <- function(x, ...){
  useMethod("as_md")
}