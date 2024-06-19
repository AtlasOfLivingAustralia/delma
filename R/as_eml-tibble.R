#' @rdname as_eml
#' @order 3
#' @exportS3Method elm::as_eml
as_eml.tbl_df <- function(x, ...){
  result <- tibble_to_list_recurse(x, level = 1)
  class(result) <- c("eml", "list")
  result
}


#' Internal function to power `parse_tibble_to_list()`
#' necessary to prevent problems if user sets `level` arg
#' @importFrom purrr map
#' @noRd
#' @keywords Internal
tibble_to_list_recurse <- function(x, level = 1){
  if(nrow(x) == 1){
    x$text
  }else{
    this_level <- x$level == level
    x_list <- split(x, cumsum(this_level))
    if(level > 1){
      x_list <- x_list[-1]
    }
    names(x_list) <- x$label[this_level]
    map(.x = x_list, 
        .f = \(a){tibble_to_list_recurse(a, level = level + 1)})    
  }
}