#' Convert metadata to a `tibble`
#' 
#' Takes objects of class `list` or `xml_document` and converts 
#' them to a tibble with a particular structure, designed for storing nested
#' data. Tibbles are required because attributes are stored as list-columns, 
#' which are not supported by class `data.frame`.
#' @name as_eml_tbl
#' @order 1
#' @param x Object to be converted
#' @param ... Other arguments, currently ignored
#' @returns An object of class `tbl_df`, `tbl` and `data.frame`, containing
#' the following fields:
#' 
#'   * `level` (int) gives the nestedness level of the node/heading in question
#'   * `label` (chr) the `xml` tag
#'   * `text` (chr) Any text stored within that tag
#'   * `attributes` (list) Any attributes for that tag
#' @examples \dontrun{
#' df <- xml2::read_xml("https://collections.ala.org.au/ws/eml/dr368") |>
#'   as_eml_tbl()
#' }
#' @export
as_eml_tbl <- function(x, ...){
  UseMethod("as_eml_tbl")
}

#' @name as_eml_tbl
#' @order 2
#' @exportS3Method delma::as_eml_tbl
as_eml_tbl.tbl_df <- function(x, ...){
  x
}

#' @rdname as_eml_tbl
#' @order 3
#' @exportS3Method delma::as_eml_tbl
as_eml_tbl.tbl_lp <- function(x, ...){
  parse_lp_to_tibble(x)
}

#' @rdname as_eml_tbl
#' @order 4
#' @exportS3Method delma::as_eml_tbl
as_eml_tbl.list <- function(x, ...){
  parse_list_to_tibble(x)
}

#' @rdname as_eml_tbl
#' @order 5
#' @exportS3Method delma::as_eml_tbl
as_eml_tbl.xml_document <- function(x, ...){
  x |>
    xml2::as_list() |>
    parse_list_to_tibble()
}