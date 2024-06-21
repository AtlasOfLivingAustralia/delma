#' @rdname as_eml
#' @order 2
#' @exportS3Method elm::as_eml
as_eml.md <- function(x, ...){
  x |>
    as_tibble() |>
    as_eml()
}