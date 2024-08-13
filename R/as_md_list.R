#' Convert metadata to class `md_list`
#' 
#' `md_list` is metadata stored as a list. It is a hack so that we don't have to 
#' overwrite `xml2::as_list` or `rlang::as_list`. In theory `eml` format should
#' be consistent with the `EML` package, but I haven't checked this.
#' @name as_md_list
#' @order 1
#' @param x Object to be converted
#' @param ... Other arguments, currently ignored
#' @export
as_md_list <- function(x, ...){
  UseMethod("as_md_list")
}

#' @rdname as_md_list
#' @order 2
#' @exportS3Method elm::as_md_list
as_md_list.md_chr <- function(x, ...){
  x |>
    parse_chr_to_tibble() |>
    parse_tibble_to_list()
}

#' @rdname as_md_list
#' @order 3
#' @exportS3Method elm::as_md_list
as_md_list.md_tibble <- function(x, ...){
  parse_tibble_to_list(x)
}

#' @rdname as_md_list
#' @order 4
#' @exportS3Method elm::as_md_list
as_md_list.md_xml <- function(x, ...){
  parse_xml_to_list(x)   
}