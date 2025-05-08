#' Convert metadata to an `xml_document`
#' 
#' Takes a `character` vector, tibble, or `list` and converts it to an 
#' `xml_document`, as defined by the `xml2` package. When converting from
#' a list, this is simply a wrapper for `xml2::as_xml_document()`.
#' @order 1
#' @param x Object to be converted.
#' @param ... Other arguments, currently ignored.
#' @name as_eml_xml
#' @returns An `xml_document` with the specified nodes and attributes.
#' @examples
#' source_file <- system.file("extdata", 
#'                            "bionet_metadata.Rmd",
#'                            package = "delma")
#' df <- read_md(source_file)
#' as_eml_list(df) |> str()
#' @export
as_eml_xml <- function(x, ...){
  UseMethod("as_eml_xml")
}

#' @rdname as_eml_xml
#' @order 2
#' @exportS3Method delma::as_eml_xml
as_eml_xml.tbl_lp <- function(x, ...){
  x |>
    parse_lp_to_tibble() |>
    parse_tibble_to_list() |>
    xml2::as_xml_document()
}

#' @rdname as_eml_xml
#' @order 3
#' @exportS3Method delma::as_eml_xml
as_eml_xml.tbl_df <- function(x, ...){
  x |>
    parse_tibble_to_list() |> 
    xml2::as_xml_document()    
}

#' @rdname as_eml_xml
#' @order 4
#' @exportS3Method delma::as_eml_xml
as_eml_xml.list <- function(x, ...){
  xml2::as_xml_document(x)
}

#' @rdname as_eml_xml
#' @order 5
#' @exportS3Method delma::as_eml_xml
as_eml_xml.xml_document <- function(x, ...){
  x
}