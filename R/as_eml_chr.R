#' Convert metadata to a `character` vector 
#' 
#' These functions take objects of class `tbl_df` (i.e. tibbles), `list` or
#' `xml_document` (from the `xml2` package), and convert them to a vector of 
#' strings that is human- and machine- readable markdown.
#' @name as_eml_chr
#' @order 1
#' @param x Object to be converted
#' @param ... Other arguments, currently ignored
#' @returns A `character` vector formatted as markdown.
#' @export
as_eml_chr <- function(x, ...){
  UseMethod("as_eml_chr")
}

#' @rdname as_eml_chr
#' @order 2
#' @exportS3Method elm::as_eml_chr
as_eml_chr.character <- function(x, ...){
  x
}

#' @rdname as_eml_chr
#' @order 3
#' @exportS3Method elm::as_eml_chr
as_eml_chr.tbl_df <- function(x, ...){
  parse_tibble_to_chr(x)
}

#' @rdname as_eml_chr
#' @order 4
#' @exportS3Method elm::as_eml_chr
as_eml_chr.list <- function(x, ...){
  x |>
    parse_list_to_tibble() |>
    parse_tibble_to_chr()
}

#' @rdname as_eml_chr
#' @order 5
#' @exportS3Method elm::as_eml_chr
as_eml_chr.xml_document <- function(x, ...){
  x |>
    parse_xml_to_list() |>
    parse_list_to_tibble() |>
    parse_tibble_to_chr()
}
