#' Convert metadata to class `md_tibble`
#' 
#' This isn't any different from a tibble, but allows us more control over 
#' OOP.
#' @name as_md_tibble
#' @order 1
#' @param x Object to be converted
#' @param ... Other arguments, currently ignored
#' @export
as_md_tibble <- function(x, ...){
  UseMethod("as_md_tibble")
}

#' @name as_md_tibble
#' @order 2
#' @exportS3Method elm::as_md_tibble
as_md_tibble.md_chr <- function(x, ...){
  parse_chr_to_tibble(x)
}

#' @rdname as_md_tibble
#' @order 3
#' @exportS3Method elm::as_md_tibble
as_md_tibble.md_list <- function(x, ...){
  parse_list_to_tibble(x)
}

#' @rdname as_md_tibble
#' @order 4
#' @exportS3Method elm::as_md_tibble
as_md_tibble.md_xml <- function(x, ...){
  x |>
    parse_xml_to_list() |>
    parse_list_to_tibble()
}