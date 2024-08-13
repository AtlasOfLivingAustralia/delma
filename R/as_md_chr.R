#' Convert metadata to class `md`
#' 
#' This is basically a vector
#' @name as_md_chr
#' @order 1
#' @param x Object to be converted
#' @param ... Other arguments, currently ignored
#' @export
as_md_chr <- function(x, ...){
  UseMethod("as_md_chr")
}

#' @rdname as_md_chr
#' @order 2
#' @exportS3Method elm::as_md_chr
as_md_chr.md_tibble <- function(x, ...){
  parse_tibble_to_chr(x)
}

#' @rdname as_md_chr
#' @order 3
#' @exportS3Method elm::as_md_chr
as_md_chr.md_list <- function(x, ...){
  x |>
    parse_list_to_tibble() |>
    parse_tibble_to_chr()
}

#' @rdname as_md_chr
#' @order 4
#' @exportS3Method elm::as_md_chr
as_md_chr.md_xml <- function(x, ...){
  x |>
    parse_xml_to_list() |>
    parse_list_to_tibble() |>
    parse_tibble_to_chr()
}