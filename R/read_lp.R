#' Internal function to read files using lightparser,
#' then append tibbles with an additional class
#' @noRd
#' @keywords Internal
read_lp <- function(file){
  x <- lightparser::split_to_tbl(file) 
  initial_class <- class(x)
  class(x) <- c("tbl_lp", initial_class)
  x
}