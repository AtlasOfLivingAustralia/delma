#' Convert metadata to class `eml`
#' 
#' `eml` is metadata stored as a list. It is a hack so that we don't have to 
#' overwrite `xml2::as_list` or `rlang::as_list`. In theory `eml` format should
#' be consistent with the `EML` package, but I haven't checked this.
#' @name as_eml
#' @param x Object to be converted
#' @param ... other arguments, currently ignored
#' @export
as_eml <- function(x, ...){
  UseMethod("as_eml")
}