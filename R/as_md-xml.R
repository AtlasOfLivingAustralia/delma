#' @rdname as_md
#' @order 4
#' @exportS3Method elm::as_md
as_md.xml_document <- function(x, ...){
  x |>
    as_eml() |>
    as_tibble() |>
    as_md()
}