#' @rdname parse_
#' @order 3
#' @importFrom xml2 as_xml_document
#' @noRd
#' @keywords Internal
parse_list_to_xml <- function(x){
  # type check
  if(!inherits(x, "list")){
    abort("`parse_list_to_xml()` only works on objects of class `list`")
  }
  
  xml2::as_xml_document(x)
} 