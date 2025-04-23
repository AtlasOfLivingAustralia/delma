#' @rdname parse_
#' @order 5
#' @noRd
#' @keywords Internal
parse_list_to_tibble <- function(x){
  result <- list_to_tibble_recurse(x)
  for(i in seq_len(purrr::pluck_depth(result))){
    result <- purrr::list_flatten(result)
  }
  result_tibble <- result |>
    clean_tbl_text_list() |>
    dplyr::bind_rows() |>
    dplyr::mutate(index_number = dplyr::row_number())
  
  # break pipe here to remove duplicates
  result_tibble <- result_tibble[!duplicated(result_tibble), ] # duplicated in any column
  # removal of duplicates is causing later issues with `ulink`
  # more broadly, though, you should be allowed to have duplicated
  # content if you want. This is a very coarse way to detect bugs
  # perhaps detecting duplicated index values?! rather than names?
  # that could work\
  
  # restart pipe
  result_tibble |>
    dplyr::select(
      dplyr::any_of(c("level", "label", "index_number", "text", "attributes"))) |>
    clean_empty_lists() |>
    clean_paragraphs()
}

#' Internal recursive function
#' @param x (list) A list constructed from xml (via `xml2::as_list()`)
#' @param level (integer) what depth are we currently in within the list
#' @param file (string) file name to save changes
#' @noRd
#' @keywords Internal
list_to_tibble_recurse <- function(x, 
                                  level = 1,
                                  outcome = xml_tibble()){
  x_names <- names(x)
  purrr::map(.x = seq_along(x),
             .f = \(a){
               # browser()
               result <- extract_list_to_tibble(a, x_names, x, level)
               if(!is.null(result)){
                 if(nrow(result) > 0){
                   current_index <- c(
                     outcome$index[[nrow(outcome)]],
                     result$index[[1]])
                   outcome <- dplyr::bind_rows(outcome, result)
                   outcome$index[[nrow(outcome)]] <- current_index[!is.na(current_index)]
                 }
               }
               if(is.list(x[[a]])){
                 if(length(x[[a]]) > 0){
                   list_to_tibble_recurse(x[[a]], 
                                          level = level + 1, 
                                          outcome = outcome) 
                 }
                 else{
                   # browser() # trying to find indexing info here
                   format_xml_tibble(outcome)
                 }
               }else if(is.character(x[[a]])){
                 # if(grepl("^Creative Commons Attribution", x[[a]])){
                 #    browser()
                 # }
                 result <- format_xml_tibble(outcome)
                 # This code is rather convoluted.
                 # Where a `para` tag includes text FOLLOWED by other tags,
                 # indexing was failing to detect it. This 're-adds' 
                 # text missing for this reason.
                 match_check <- result$text[nrow(result)] == x[[a]]
                 if(is.na(match_check) | isFALSE(match_check)){
                   result <- result |>
                     tibble::add_row(
                       level = level,
                       label = NA,
                       attributes = list(NA),
                       text = x[[a]]
                     )
                 }
                 result 
               }else{
                 format_xml_tibble(outcome) 
               }
             }
  )
}

#' get information as tibble in list_to_tibble_recurse
#' @noRd
#' @keywords Internal
extract_list_to_tibble <- function(index, list_names, list_data, level){
  if(is.null(list_names[index])){
    xml_tibble(level = level, 
               text = list_data[[1]],
               index = index)
  }else if(list_names[index] != ""){
    current_contents <- list_data[[index]]
    current_attr <- attributes(current_contents)
    # current_title <- snakecase::to_title_case(list_names[index])
    result <- xml_tibble(level = level,
                         label = list_names[index],
                         index = index)
    if(length(current_attr) >= 1){
      non_name_attributes <- current_attr[names(current_attr) != "names"] |>
        replace_xml_quotes()
      result$attributes[1] <- list(non_name_attributes)
    }else{
      result$attributes <- list(NA)
    }
    if(inherits(current_contents, "character")){
      result$text <- current_contents
    }
    result
  }else{
    NULL
  }
}

#' Internal function to replace "\"" with "&quot;"
#' Former is created by xml2 somewhere, even when source says latter.
#' @noRd
#' @keywords Internal
replace_xml_quotes <- function(x){
  purrr::map(x,
    \(a){
      if(a == "\""){
        "&quot;"
      }else{
        a
      }
    })
}

#' empty tibble content
#' @noRd
#' @keywords Internal
xml_tibble <- function(level = NA,
                       label = NA,
                       attributes = NA,
                       text = NA,
                       index = NA){
  tibble::tibble(
    level = as.integer(level),
    label = as.character(label),
    attributes = as.list(attributes),
    text = as.character(text),
    index = as.list(index)
    )
}

#' Internal function to format a tibble from list
#' @noRd
#' @keywords Internal
format_xml_tibble <- function(df){
  df <- df[-1, ] # top row is empty
  index_names <- purrr::map(.x = seq_len(nrow(df)), 
                      .f = \(a){
                        paste(df$label[seq_len(a)], collapse = "_")
                      }) |>
    unlist()
  df$index_names <- index_names 
  df
}

#' Internal function to clean tibbles for aggregating
#' @param x a flat list (i.e. no nesting) containing one tibble per entry
#' @noRd
#' @keywords Internal
clean_tbl_text_list <- function(x){
  purrr::map(x, \(a){
    if(is.null(a)){
      a
    }else{
      n <- nrow(a)
      if(!is.na(a$text[n]) & is.na(a$text[(n - 1)]) & is.na(a$label[n])){
        a$text[n - 1] <- a$text[n]
        dplyr::slice_head(a, n = (n - 1))
      }else{
        a
      }      
    }
  })
}

#' Internal function to look for empty named lists; replace with list(NA)
#' @param x a tibble with a list-column named `attributes`
#' @noRd
#' @keywords Internal
clean_empty_lists <- function(x){
  list_check <- purrr::map(x$attributes, \(a){inherits(a, "list")}) |>
    unlist()
  list_entries <- x$attributes[list_check]
  x$attributes[list_check] <- purrr::map(list_entries, 
                                         \(a){if(length(a) < 1){NA}else{a}})
  x
}

#' Internal function to consolidate paragraphs
#' @param x a tibble with a chr-column named `label`
#' @noRd
#' @keywords Internal
clean_paragraphs <- function(x){
  x <- x |> 
    dplyr::mutate(text = as.list(.data$text),
                  index = seq_len(nrow(x)),
                  group = detect_paras(.data$label))
  if(any(x$group > 0)){
    x_subset <- x |>
      dplyr::filter(.data$group > 0) 
    x_split <- split(x_subset, x_subset$group)
    result_split <- purrr::map(x_split, \(a){
      tibble::tibble(
        level = a$level[1],
        label = a$label[1],
        text =  list(as.list(a$text[seq(from = 2, to = nrow(a), by = 1)])),
        attributes = a$attributes[1],
        group = 0,
        index = a$index[1])
    })
    dplyr::bind_rows(result_split) |>
      dplyr::bind_rows(x) |>
      dplyr::filter(.data$group < 1) |>
      dplyr::arrange(.data$index) |>
      dplyr::select(c("level", "label", "index_number", "text", "attributes"))
  }else{
    x |>
      dplyr::select(c("level", "label", "index_number", "text", "attributes"))
  }
}

#' Internal function to detect paragraphs
#' @param y a vector of labels
#' @noRd
#' @keywords Internal
detect_paras <- function(y){
  n <- length(y)
  result <- vector(mode = "integer", length = n)
  value <- 0
  for(i in seq_len(n)){
    if(i > 1 & i < n){
      # if(i == 6){browser()}
      if(y[i] != "Para" & y[(i + 1)] == "Para"){
        value <- value + 1
        result[i] <- value
      }else if(y[i] == "Para"){
        result[i] <- value
      }else{
        result[i] <- 0
      }
    }else{
      result[i] <- 0
    }
  }
  result
}