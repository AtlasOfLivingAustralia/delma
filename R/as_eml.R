#' Generic function to convert to EML
#' 
#' In test
#' @name as_eml
#' @export
as_eml <- function(x, ...){
  UseMethod("as_eml")
}

#' @rdname as_eml
#' @order 2
#' @export
as_eml.tbl_df <- function(x){
  x |>
    parse_tibble_to_list() |>
    xml2::as_xml_document()
}