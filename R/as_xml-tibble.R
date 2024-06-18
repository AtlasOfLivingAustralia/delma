#' @rdname as_xml
#' @order 4
#' @exportS3Method elm::as_xml
as_xml.tbl_df <- function(x){
  x |>
    as_eml() |>
    as_xml()
}
