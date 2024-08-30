#' Convert metadata to a `list`
#' 
#' Takes an object of class `character`, `xml_document` or a tibble, and 
#' converts it to a `list`.
#' @name as_md_list
#' @order 1
#' @param x Object to be converted
#' @param ... Other arguments, currently ignored
#' @returns A list, where both the nested structure of the XML/md and the 
#' attributes of XML nodes, are preserved.
#' @export
as_md_list <- function(x, ...){
  UseMethod("as_md_list")
}

#' @rdname as_md_list
#' @order 2
#' @exportS3Method elm::as_md_list
as_md_list.character <- function(x, ...){
  x |>
    parse_chr_to_tibble() |>
    parse_tibble_to_list()
}

#' @rdname as_md_list
#' @order 3
#' @exportS3Method elm::as_md_list
as_md_list.tbl_df <- function(x, ...){
  parse_tibble_to_list(x)
}

#' @rdname as_md_list
#' @order 4
#' @exportS3Method elm::as_md_list
as_md_list.list <- function(x, ...){
  x
}

#' @rdname as_md_list
#' @order 5
#' @exportS3Method elm::as_md_list
as_md_list.xml_document <- function(x, ...){
  parse_xml_to_list(x)   
}