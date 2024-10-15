#' Convert metadata to a `tibble`
#' 
#' Takes objects of class `character`, `list` or `xml_document` and converts 
#' them to a tibble with a particular structure, designed for storing nested
#' data. Tibbles are required because attributes are stored as list-columns, 
#' which are not supported by class `data.frame`.
#' @name as_eml_tibble
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
#' @export
as_eml_tibble <- function(x, ...){
  UseMethod("as_eml_tibble")
}

#' @name as_eml_tibble
#' @order 2
#' @exportS3Method elm::as_eml_tibble
as_eml_tibble.character <- function(x, ...){
  parse_chr_to_tibble(x)
}

#' @name as_eml_tibble
#' @order 3
#' @exportS3Method elm::as_eml_tibble
as_eml_tibble.tbl_df <- function(x, ...){
  x
}

#' @rdname as_eml_tibble
#' @order 4
#' @exportS3Method elm::as_eml_tibble
as_eml_tibble.list <- function(x, ...){
  parse_list_to_tibble(x)
}

#' @rdname as_eml_tibble
#' @order 5
#' @exportS3Method elm::as_eml_tibble
as_eml_tibble.xml_document <- function(x, ...){
  x |>
    parse_xml_to_list() |>
    parse_list_to_tibble()
}
