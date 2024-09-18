#' Convert metadata to an `xml_document`
#' 
#' Takes a `character` vector, tibble, or `list` and converts it to an 
#' `xml_document`, as defined by the `xml2` package.
#' @order 1
#' @param x Object to be converted
#' @param ... Other arguments, currently ignored
#' @name as_elm_xml
#' @returns An `xml_document` with the specified nodes and attributes.
#' @export
as_elm_xml <- function(x, ...){
  UseMethod("as_elm_xml")
}

#' @rdname as_elm_xml
#' @order 2
#' @exportS3Method elm::as_elm_xml
as_elm_xml.character <- function(x, ...){
  x |>
    parse_chr_to_tibble() |>
    parse_tibble_to_list() |>
    parse_list_to_xml()
}

#' @rdname as_elm_xml
#' @order 3
#' @exportS3Method elm::as_elm_xml
as_elm_xml.tbl_df <- function(x, ...){
  x |>
    parse_tibble_to_list() |>
    parse_list_to_xml()
}

#' @rdname as_elm_xml
#' @order 4
#' @exportS3Method elm::as_elm_xml
as_elm_xml.list <- function(x, ...){
  parse_list_to_xml(x)
}

#' @rdname as_elm_xml
#' @order 5
#' @exportS3Method elm::as_elm_xml
as_elm_xml.xml_document <- function(x, ...){
  x
}
