#' @rdname parse_
#' @order 2
#' @importFrom rlang .data
#' @noRd
#' @keywords Internal
parse_tibble_to_list <- function(x){
  x <- x |>
    add_para_tags() |>
    remove_empty_rows()
  result <- tibble_to_list_recurse(x, level = 1)
  add_tibble_attributes_to_list(empty = result,
                                full = x)
}

#' Internal function to ensure lists in `text` column are parsed correctly.
#' Requires modification to add `<para>` tag within list-entries
#' @noRd
#' @keywords Internal
add_para_tags <- function(x){
  if(!any(colnames(x) == "text")){
    cli::cli_abort("Supplied tibble doesn't contain required column `text`", 
                  call = rlang::caller_env())
  }
  
  # identify text that requires para tags (long text entries that aren't urls)
  text_summary <- x |>
    split(f = seq_along(x$text)) |> # equivalent to `group_split()`
    purrr::map(
      \(df){
        df |>
          dplyr::mutate(
            n_chr = cli::ansi_nchar(text),
            is_a_url = stringr::str_starts(as.character(text), "http"),
            is_a_list = purrr::map(text, \(a){inherits(a, "list")}) |> unlist(),
            # para tag candidates
            needs_para_tag = dplyr::case_when(
              (n_chr > 60 | is_a_list) & !is_a_url ~ TRUE,
              .default = FALSE
              )
          )
      }
    ) |> 
    dplyr::bind_rows() 
  
  if (any(text_summary$needs_para_tag)) {
    # add para tag
    x <- text_summary |>
      dplyr::mutate(
        text = dplyr::case_when(
          needs_para_tag ~ purrr::map(text,
                                      \(a){
                                        result <- purrr::map(a, \(b){list(b)})
                                        names(result) <- rep("para", length(result))
                                        result
                                        }
                                      ), 
          .default = text
          )
        ) |>
      dplyr::select("level", "label", "text", "attributes")
  }
  x
}

#' Internal function to remove tibble rows without useful information
#' @noRd
#' @keywords Internal
remove_empty_rows <- function(x){
  text_na <- is_na_list(x$text)
  attributes_na <- is_na_list(x$attributes)
  label_na <- is.na(x$label)
  x[!(label_na & text_na & attributes_na), ]
}

#' Internal function to find length-1 NA entries in list-columns
#' @noRd
#' @keywords Internal
is_na_list <- function(a){
  purrr::map(a,
             \(b){
               if(length(b) == 1){
                 if(is.na(b[[1]])){
                   TRUE
                 }else{FALSE}
               }else{FALSE}
             }) |>
    unlist()
}

#' Internal function to power `parse_tibble_to_list()`
#' necessary to prevent problems if user sets `level` arg
#' @noRd
#' @keywords Internal
tibble_to_list_recurse <- function(x, level = 1){
  if(nrow(x) == 1){
    if(is.na(x$text)){
      list()
    }else{
      if(length(x$text[[1]]) > 1){
        x$text[[1]]
      }else{
        x$text
      }
    }
  }else{
    this_level <- x$level == level
    x_list <- split(x, cumsum(this_level))
    if(level > 1){
      x_list <- x_list[-1]
    }
    current_label <- x$label[this_level]
    names(x_list) <- current_label
    purrr::map(.x = x_list, 
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


