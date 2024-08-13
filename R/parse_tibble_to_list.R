#' @rdname parse_
#' @order 2
#' @export
parse_tibble_to_list <- function(x){
  # type check
  if(!inherits(x, c("md_tibble", "tbl_df"))){
    abort("`parse_chr_to_tibble()` only works on objects of class `md_tibble` or `tbl_df`")
  }
  
  result <- tibble_to_list_recurse(x, level = 1)
  class(result) <- c("md_list", "list")
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