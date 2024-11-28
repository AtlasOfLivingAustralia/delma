#' @rdname parse_
#' @order 4
#' @param x an R object of the requisite type. No type checking is done.
#' @importFrom xml2 as_list
#' @noRd
#' @keywords Internal
parse_xml_to_list <- function(x)
{
  # type check
  if(!inherits(x, c("xml_document", "xml_node"))){
    abort("`parse_chr_to_tibble()` only works on objects of class `xml_document`")
  }
  
  xml2::as_list(x)
}