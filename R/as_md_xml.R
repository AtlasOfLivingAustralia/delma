#' Convert metadata to class `md_xml`
#' 
#' largely powered by `xml2`
#' @order 1
#' @param x Object to be converted
#' @param ... Other arguments, currently ignored
#' @name as_md_xml
#' @export
as_md_xml <- function(x, ...){
  UseMethod("as_md_xml")
}

#' @rdname as_md_xml
#' @order 2
#' @exportS3Method elm::as_md_xml
as_md_xml.md_chr <- function(x, ...){
  x |>
    parse_chr_to_tibble() |>
    parse_tibble_to_list() |>
    parse_list_to_xml()
}

#' @rdname as_md_xml
#' @order 3
#' @exportS3Method elm::as_md_xml
as_md_xml.md_tibble <- function(x, ...){
  x |>
    parse_tibble_to_list() |>
    parse_list_to_xml()
}

#' @rdname as_md_xml
#' @order 4
#' @exportS3Method elm::as_md_xml
as_md_xml.md_list <- function(x, ...){
  parse_list_to_xml(x)
}