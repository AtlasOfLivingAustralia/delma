#' @rdname as_tibble-eml
#' @order 3
#' @exportS3Method tibble::as_tibble
as_tibble.xml_document <- function(x, ...){
  x |>
    as_eml() |>
    as_tibble()
}