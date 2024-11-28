#' @rdname parse_
#' @order 2
#' @importFrom rlang .data
#' @importFrom snakecase to_lower_camel_case
#' @noRd
#' @keywords Internal
parse_tibble_to_list <- function(x){
  if(!inherits(x, "tbl_df")){
    abort("`parse_chr_to_tibble()` only works on objects of class `tbl_df`")
  }
  x <- mutate(x,
              label = to_lower_camel_case(.data$label))
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
    current_label <- x$label[this_level]
    # if(!is.na(current_label)){
      names(x_list) <- current_label
    # }
    map(.x = x_list, 
        .f = \(a){tibble_to_list_recurse(a, level = level + 1)})    
  }
}

#' Internal function to take xml attributes and parse them properly onto a list
#' @noRd
#' @keywords Internal
add_tibble_attributes_to_list <- function(empty, full){
  # get a list giving the structure of the supplied tibble
  index_list <- get_list_addresses(full$level)
  
  # walk along the list and assign attributes back to `clean_result`
  for(a in seq_along(index_list)){ # using purrr::walk here fails
    b <- index_list[[a]]
    # first get names
    names_vector <- names(`[[`(empty, b))
    if(length(names_vector) > 0){
      names_list <- list(names = names_vector)
    }else{
      names_list <- NULL
    }
    # then remaining attributes
    attributes_list <- full$attributes[[a]]
    if(length(attributes_list) < 1){
      attributes_list <- NULL
    } else if(length(attributes_list) == 1){
      if(is.na(attributes_list)){
        attributes_list <- NULL
      }
    }
    # append together and assign
    attributes_all <- append(names_list, attributes_list)
    attributes(`[[`(empty, b)) <- attributes_all
  }
  empty
}

#' Internal function to represent `level` as list address
#' @noRd
#' @keywords Internal
get_list_addresses <- function(level){
  
  # set up basic info
  n_levels <- max(level)
  level_index <- rep(1, n_levels)
  address_list <- vector(mode = "list", 
                         length = length(level))
  
  # run a loop to build the addresses
  for(i in seq_along(address_list)){
    current_level <- level[i]
    if(i > 1){
      prev_level <- level[(i - 1)]
      # if you are remaining at the same level, iterate by 1
      if(current_level == prev_level){
        level_index[current_level] <- level_index[current_level] + 1
      } else if(current_level < prev_level){
        # reset higher levels
        wipe_levels <- seq_len(n_levels)[-seq_len(current_level)]
        level_index[wipe_levels] <- 1
        # add one to current level
        level_index[current_level] <- level_index[current_level] + 1
      }
    }
    address_list[[i]] <- level_index[seq_len(current_level)]
  }
  
  address_list
}