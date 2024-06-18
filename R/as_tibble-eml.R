#' @importFrom dplyr bind_rows
#' @importFrom dplyr select
#' @importFrom purrr list_flatten
#' @importFrom purrr pluck_depth
#' @rdname as_tibble
#' @order 2
#' @exportS3Method tibble::as_tibble
as_tibble.eml <- function(x){
  result <- list_to_tibble_recurse(x)
  for(i in seq_len(pluck_depth(result))){
    result <- list_flatten(result)
  }
  result <- bind_rows(result)
  result <- result[!duplicated(result), ] # duplicated in any column
  select(result, "level", "label", "attributes", "text")
}

#' Internal recursive function
#' @param x (list) A list constructed from xml (via `xml2::as_list()`)
#' @param level (integer) what depth are we currently in within the list
#' @param file (string) file name to save changes
#' @importFrom dplyr anti_join
#' @importFrom dplyr bind_rows
#' @noRd
#' @keywords Internal
eml_to_tibble_recurse <- function(x, 
                                   level = 1,
                                   outcome = xml_tibble()){
  x_names <- names(x)
  map(.x = seq_along(x),
      .f = \(a){
        result <- extract_list_to_tibble(a, x_names, x, level)
        if(!is.null(result)){
          if(nrow(result) > 0){
            outcome <- bind_rows(outcome, result)
          }
        }
        if(is.list(x[[a]])){
          # if(length(x[[a]]) > 0){
          list_to_tibble_recurse(x[[a]], level = level + 1, outcome = outcome) 
          # }else{
          #   format_xml_tibble(outcome)
          # }
        }else{
          format_xml_tibble(outcome)
        }
      }
  )
}

#' get information as tibble in list_to_tibble_recurse
#' @importFrom snakecase to_title_case
#' @noRd
#' @keywords Internal
extract_list_to_tibble <- function(index, list_names, list_data, level){
  # if(length(list_names) < 1){browser()}
  if(list_names[index] != ""){
    current_contents <- list_data[[index]]
    current_attr <- attributes(current_contents)
    current_title <- to_title_case(list_names[index])
    result <- xml_tibble(level = level,
                         label = current_title)
    if(length(current_attr) > 1){
      result$attributes[1] <- list(current_attr[names(current_attr) != "names"])
    }
    if(inherits(current_contents, "character")){
      result$text <- current_contents
    }
    result
  }else{
    NULL
  }
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