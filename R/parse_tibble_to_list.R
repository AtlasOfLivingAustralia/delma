#' @rdname parse_
#' @order 2
#' @export
parse_tibble_to_list <- function(x){
  if(!inherits(x, "tbl_df")){
    abort("`parse_chr_to_tibble()` only works on objects of class `tbl_df`")
  }
  result <- tibble_to_list_recurse(x, level = 1)
  add_tibble_attributes_to_list(result, x)
}

#' Internal function to power `parse_tibble_to_list()`
#' necessary to prevent problems if user sets `level` arg
#' @importFrom purrr map
#' @noRd
#' @keywords Internal
tibble_to_list_recurse <- function(x, level = 1){
  if(nrow(x) == 1){
    if(is.na(x$text)){
      list()
    }else{
      x$text 
    }
  }else{
    this_level <- x$level == level
    x_list <- split(x, cumsum(this_level))
    if(level > 1){
      x_list <- x_list[-1]
    }
    current_label <- x$label[this_level] |>
      tolower()
    # if(!is.na(current_label)){
      names(x_list) <- current_label
    # }
    map(.x = x_list, 
        .f = \(a){tibble_to_list_recurse(a, level = level + 1)})    
  }
}