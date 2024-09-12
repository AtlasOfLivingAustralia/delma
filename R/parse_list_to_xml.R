#' @rdname parse_
#' @order 3
#' @importFrom xml2 as_xml_document
#' @export
parse_list_to_xml <- function(x){
  # type check
  if(!inherits(x, "list")){
    abort("`parse_chr_to_tibble()` only works on objects of class `list`")
  }
  
  xml2::as_xml_document(x)
} 