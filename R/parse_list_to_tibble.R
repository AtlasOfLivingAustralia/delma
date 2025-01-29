#' @rdname parse_
#' @order 5
#' @importFrom purrr list_flatten
#' @importFrom purrr pluck_depth
#' @noRd
#' @keywords Internal
parse_list_to_tibble <- function(x){
  result <- list_to_tibble_recurse(x)
  for(i in seq_len(pluck_depth(result))){
    result <- list_flatten(result)
  }
  result_tibble <- result |>
    clean_tibble_text() |>
    dplyr::bind_rows() |>
    dplyr::select(dplyr::any_of(
      c("level", "label", "text", "attributes")))
  result_tibble <- result_tibble[!duplicated(result_tibble), ] # duplicated in any column
  result_tibble |>
    clean_empty_lists() |>
    clean_paragraphs()
}

#' Internal function to clean tibbles for aggregating
#' @param x a flat list (i.e. no nesting) containing one tibble per entry
#' @noRd
#' @keywords Internal
clean_tibble_text <- function(x){
  map(x, \(a){
    n <- nrow(a)
    if(!is.na(a$text[n]) & is.na(a$text[(n - 1)]) & is.na(a$label[n])){
      a$text[n - 1] <- a$text[n]
      dplyr::slice_head(a, n = (n - 1))
    }else{
      a
    }
  })
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

#' Internal function to consolidate paragraphs
#' @param x a tibble with a chr-column named `label`
#' @noRd
#' @keywords Internal
clean_paragraphs <- function(x){
  x <- x |> mutate(
    text = as.list(.data$text),
    index = seq_len(nrow(x)),
    group = detect_paras(.data$label))
  if(any(x$group > 0)){
    x_subset <- x |>
      dplyr::filter(.data$group > 0) 
    x_split <- split(x_subset, x_subset$group)
    result_split <- map(x_split, \(a){
      tibble(
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
      dplyr::select(c("level", "label", "text", "attributes"))
  }else{
    x |>
      dplyr::select(c("level", "label", "text", "attributes"))
  }
}

#' Internal function to look for empty named lists; replace with list(NA)
#' @param x a tibble with a list-column named `attributes`
#' @noRd
#' @keywords Internal
clean_empty_lists <- function(x){
  list_check <- map(x$attributes, \(a){inherits(a, "list")}) |>
    unlist()
  list_entries <- x$attributes[list_check]
  x$attributes[list_check] <- map(list_entries, 
                                  \(a){if(length(a) < 1){NA}else{a}})
  x
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
  map(.x = seq_along(x),
      .f = \(a){
        result <- extract_list_to_tibble(a, x_names, x, level)
        if(!is.null(result)){
          if(nrow(result) > 0){
            outcome <- dplyr::bind_rows(outcome, result)
          }
        }
        if(is.list(x[[a]])){
          if(length(x[[a]]) > 0){
            list_to_tibble_recurse(x[[a]], 
                                   level = level + 1, 
                                   outcome = outcome) 
          }
          ## This is cancelled because it apparently never gets called
          # else{
          #   browser()
          #   format_xml_tibble(outcome)
          # }
        }else{
          format_xml_tibble(outcome) 
            # dplyr::slice_tail()
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
               text = list_data[[1]])
  }else if(list_names[index] != ""){
    current_contents <- list_data[[index]]
    current_attr <- attributes(current_contents)
    current_title <- snakecase::to_title_case(list_names[index])
    result <- xml_tibble(level = level,
                         label = current_title)
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
  map(x,
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
                       text = NA){
  tibble(
    level = as.integer(level),
    label = as.character(label),
    attributes = as.list(attributes),
    text = as.character(text))
}

#' Internal function to format a tibble from list
#' @noRd
#' @keywords Internal
format_xml_tibble <- function(df){
  df <- df[-1, ] # top row is empty
  index <- map(.x = seq_len(nrow(df)), 
               .f = \(a){paste(df$label[seq_len(a)], collapse = "_")}) |>
    unlist()
  df$index <- index 
  df
}