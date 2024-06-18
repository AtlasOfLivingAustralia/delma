#' @rdname as_md
#' @order 3
#' @exportS3Method elm::as_md
as_md.eml <- function(x, ...){
  x |>
    as_tibble() |>
    as_md()
}