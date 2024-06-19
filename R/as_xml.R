#' Convert metadata to class `xml`
#' 
#' largely powered by `xml2`
#' @param x Object to be converted
#' @param ... other arguments, currently ignored
#' @name as_xml
#' @export
as_xml <- function(x, ...){
  UseMethod("as_xml")
}