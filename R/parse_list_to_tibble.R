#' @rdname parse_
#' @order 5
#' @importFrom dplyr any_of
#' @importFrom dplyr bind_rows
#' @importFrom dplyr select
#' @importFrom purrr list_flatten
#' @importFrom purrr pluck_depth
#' @export
parse_list_to_tibble <- function(x){
  
  # type check
  if(!inherits(x, "list")){
    abort("`parse_list_to_tibble()` only works on objects of class `list`")
  }
  
  result <- list_to_tibble_recurse(x)
  for(i in seq_len(pluck_depth(result))){
    result <- list_flatten(result)
  }
  result <- bind_rows(result)
  result <- result[!duplicated(result), ] # duplicated in any column
  # NOTE: it is unclear exactly why the above line is present
  # would we expect duplicated content? Under which circumstances?
  select(result, 
         any_of(c("level", "label", "text", "attributes")))
}

#' Internal recursive function
#' @param x (list) A list constructed from xml (via `xml2::as_list()`)
#' @param level (integer) what depth are we currently in within the list
#' @param file (string) file name to save changes
#' @importFrom dplyr anti_join
#' @importFrom dplyr bind_rows
#' @noRd
#' @keywords Internal
list_to_tibble_recurse <- function(x, 
                                  level = 1,
                                  outcome = xml_tibble()){
  x_names <- names(x)
  # if(level == 3) { browser() }
  # if(any(x_names == "id")){browser()}
  map(.x = seq_along(x),
      .f = \(a){
        result <- extract_list_to_tibble(a, x_names, x, level)
        if(!is.null(result)){
          if(nrow(result) > 0){
            outcome <- bind_rows(outcome, result)
          }
        }
        if(is.list(x[[a]])){
          if(length(x[[a]]) > 0){
            list_to_tibble_recurse(x[[a]], level = level + 1, outcome = outcome) 
          }else{
            format_xml_tibble(outcome)
          }
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
  if(is.null(list_names[index])){
    xml_tibble(level = level, 
               text = list_data[[1]])
  }else if(list_names[index] != ""){
    current_contents <- list_data[[index]]
    current_attr <- attributes(current_contents)
    current_title <- to_title_case(list_names[index])
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
#' Former is created by xml2 somewhere, even when source says lattter.
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