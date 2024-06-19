#' @rdname as_xml
#' @importFrom xml2 as_xml_document
#' @order 4
#' @exportS3Method elm::as_xml
as_xml.eml <- function(x, ...){
  x |>
    eml_to_xml_recurse() |>
    append_attributes(full = x) |>
    as_xml_document()
}

#' Drill into list constructed from xml to ensure terminal nodes are correct
#' @importFrom purrr map
#' @noRd
#' @keywords Internal
eml_to_xml_recurse <- function(x){
  map(.x = x,
      .f = \(a){
        if(is.list(a)){
          eml_to_xml_recurse(a)
        }else{
          list(a)
        }
      })
}