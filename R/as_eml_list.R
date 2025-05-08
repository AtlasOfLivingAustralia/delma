#' Convert metadata to a `list`
#' 
#' Takes an object of class `xml_document` or `tibble`, and 
#' converts it to a `list`. When converting from an `xml_document`, this is 
#' simply a wrapper for `xml2::as_list()`
#' @name as_eml_list
#' @order 1
#' @param x Object to be converted
#' @param ... Other arguments, currently ignored
#' @returns A list, where both the nested structure of the XML/md and the 
#' attributes of XML nodes, are preserved.
#' @examples 
#' source_file <- system.file("extdata", 
#'                            "bionet_metadata.Rmd",
#'                            package = "delma")
#' df <- read_md(source_file)
#' as_eml_list(df) |> str()
#' @export
as_eml_list <- function(x, ...){
  UseMethod("as_eml_list")
}

#' @rdname as_eml_list
#' @order 2
#' @exportS3Method delma::as_eml_list
as_eml_list.tbl_lp <- function(x, ...){
  x |>
    parse_lp_to_tibble() |>
    parse_tibble_to_list()
}

#' @rdname as_eml_list
#' @order 3
#' @exportS3Method delma::as_eml_list
as_eml_list.tbl_df <- function(x, ...){
  parse_tibble_to_list(x)
}

#' @rdname as_eml_list
#' @order 4
#' @exportS3Method delma::as_eml_list
as_eml_list.list <- function(x, ...){
  x
}

#' @rdname as_eml_list
#' @order 5
#' @exportS3Method delma::as_eml_list
as_eml_list.xml_document <- function(x, ...){
  xml2::as_list(x) 
}