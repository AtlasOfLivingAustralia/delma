
#' Internal function to add attributes back to a list where they have been
#' removed by lapply or map
#' @importFrom purrr pluck
#' @noRd
#' @keywords Internal
append_attributes <- function(empty, full){
  # try using numeric indexes to set attributes
  # NOTE: using addresses (i.e. `names(x_list)`) doesn't work, because names can be duplicated
  index_list <- get_index(empty)
  
  # walk along the list and assign attributes back to `clean_result`
  for(a in seq_along(index_list)){ # using purrr::walk here fails
    b <- index_list[[a]]
    z <- pluck(full, !!!b)
    attributes(`[[`(empty, b)) <- attributes(z) # do not replace with `pluck()<-`
  }
  # return
  empty
}


#' clean up the output from `index_recurse()`
#' @importFrom purrr list_flatten
#' @importFrom purrr map
#' @importFrom purrr pluck_depth
#' @noRd
#' @keywords Internal
get_index <- function(x){
  address_list <- index_recurse(x)
  # flatten lists
  n <- pluck_depth(address_list) - 1
  for(i in seq_len(n)){
    address_list <- list_flatten(address_list)
  }
  # get all unique addresses
  address_lengths <- lengths(address_list)
  n_max <- max(address_lengths)
  map(.x = seq_len(n_max), 
      .f = \(a){
        address_tmp <- address_list[address_lengths >= a]
        result <- map(address_tmp, .f = \(b){b[seq_len(a)]})
        result[!duplicated(result)]
      }) |>
    list_flatten()
}

#' drill into a list to get the 'index'; i.e. a numeric map of the list
#' @importFrom purrr map
#' @noRd
#' @keywords Internal
index_recurse <- function(x, 
                          level = 1,
                          index_accumulate = list()){
  if(is.list(x)){
    map(.x = seq_len(length(x)),
        .f = \(a){
          index_recurse(x[[a]], 
                        level = level + 1,
                        index_accumulate = unlist(c(index_accumulate, a))
          )})    
  }else{
    index_accumulate
  }
}
# note this isn't perfect yet. Some terminal nodes still parse to `list()`