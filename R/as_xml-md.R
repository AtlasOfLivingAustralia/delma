#' @rdname as_xml
#' @order 2
#' @exportS3Method elm::as_xml
as_xml.md <- function(x){
  x |>
    as_tibble() |>
    as_eml() |>
    as_xml()
}