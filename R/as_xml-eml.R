#' @rdname as_xml
#' @importFrom xml2 as_xml_document
#' @order 4
#' @exportS3Method elm::as_xml
as_xml.eml <- function(x, ...){
  x |>
    as_xml_document() # TODO: this doesn't reverse `parse_xml_to_list()` yet
}