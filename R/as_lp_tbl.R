#' Convert metadata to a lightparser `tibble`
#' 
#' Takes objects of class `tbl_df`, `list` or `xml_document` and converts 
#' them to a tibble with a structure required by `lightparser`. Note that 
#' `delma` represents these as an object of class `tbl_lp` for convenience.
#' @name as_lp_tbl
#' @order 1
#' @param x Object to be converted
#' @param ... Other arguments, currently ignored
#' @returns An object of class `tbl_lp`, `tbl_df`, `tbl` and `data.frame`, containing
#' the following fields:
#' 
#'   * `type` (chr) Whether that section is e.g. YAML, inline text, heading, or code block
#'   * `label` (chr) The tag associated with a given code block (otherwise NA)
#'   * `params` (list) Attributes of a code block
#'   * `text` (list) Any text in that section
#'   * `code` (list) Any code in that section
#'   * `heading` (chr) For `type` = `heading`, the value of that heading
#'   * `heading_level` (dbl) The heading level of that heading (i.e. number of `#`)
#'   * `section` (chr) The heading this section sits within
#' @examples \dontrun{
#' df <- xml2::read_xml("https://collections.ala.org.au/ws/eml/dr368") |>
#'   as_lp_tbl()
#' }
#' @export
as_lp_tbl <- function(x, ...){
  UseMethod("as_lp_tbl")
}

#' @name as_lp_tbl
#' @order 2
#' @exportS3Method delma::as_lp_tbl
as_lp_tbl.tbl_lp <- function(x, ...){
  x
}

#' @name as_lp_tbl
#' @order 3
#' @exportS3Method delma::as_lp_tbl
as_lp_tbl.tbl_df <- function(x, ...){
  parse_tibble_to_lp(x)
}

#' @rdname as_lp_tbl
#' @order 4
#' @exportS3Method delma::as_lp_tbl
as_lp_tbl.list <- function(x, ...){
  x |>
    parse_list_to_tibble() |>
    parse_tibble_to_lp()
}

#' @rdname as_lp_tbl
#' @order 5
#' @exportS3Method delma::as_lp_tbl
as_lp_tbl.xml_document <- function(x, ...){
  x |>
    xml2::as_list() |>
    parse_list_to_tibble() |>
    parse_tibble_to_lp()
}