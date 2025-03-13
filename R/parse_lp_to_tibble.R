#' Internal function to convert `lightparser` tibble to `delma` format
#' @param x A tibble
#' @noRd
#' @keywords Internal
parse_lp_to_tibble <- function(x){
  x |>
    clean_header_level() |> # downfill heading level
    dplyr::mutate(attributes = as.list(rep(NA, nrow(x)))) |>
    dplyr::filter(.data$type != "yaml",
                  is.na(.data$heading),
                  .data$heading_level > 0) |>
    clean_text() |>
    clean_urls() |>
    dplyr::select("heading_level", "section", "text", "attributes") |>
    dplyr::rename("level" = "heading_level", 
                  "label" = "section") |>
    clean_eml_tags()
}

#' Internal function to clean header levels
#' @param x a tibble with the column heading level
#' @noRd
#' @keywords Internal
clean_header_level <- function(x){
  heading_value <- 0
  for(i in c(2:nrow(x))){
    if(!is.na(x$heading_level[i])){
      heading_value <- x$heading_level[i]
    }else{
      x$heading_level[i] <- heading_value
    }
  }
  x
}

#' Internal function to clean text column
#' @param x A tibble
#' @noRd
#' @keywords Internal
clean_text <- function(x){
  result <- purrr::map(x$text,
                       \(a){
                         a <- trimws(a)
                         if(length(a) < 2){
                           if(a == ""){
                             NA
                           }else{
                             a
                           }
                         }else{
                           if(any(a == "")){
                             a[a == ""] <- "{BREAKPOINT}"
                             b <- glue::glue_collapse(a, sep = " ") |>
                               strsplit(split = "\\{BREAKPOINT\\}") |>
                               purrr::pluck(!!!list(1)) |>
                               trimws() |>
                               stringr::str_replace("\\s{2,}", "\\s")
                             b <- b[b != ""] # remove empty spaces; typically a leading ""
                             if(length(b) > 1){
                               as.list(b) # lists are parsed as paragraphs
                             }else{
                               b # length-1 characters are not
                             }
                           }else{
                             glue::glue_collapse(x, sep = " ") |>
                               as.character()
                           }                 
                         }
                       })
  names(result) <- NULL
  x$text <- result
  x
}

#' Internal function to clean urls in a text column (remove leading and trailing <>)
#' @param x A tibble
#' @noRd
#' @keywords Internal
clean_urls <- function(x){
  result <- purrr::map(x$text, \(a){
    if(inherits(a, "list")){
      purrr::map(a, clean_url)  
    }else{
      clean_url(a)
    }
  })
  x$text <- result
  x
}

#' Internal function to clean_urls() for a single string
#' @param x A length-1 string
#' @noRd
#' @keywords Internal
clean_url <- function(x){
  if(is.na(x)){
    x
  }else{
    if(grepl("^<", x) & grepl(">$", x)){ # includes urls and html comments
      if(grepl("^<!--", x) & grepl("-->$", x)){ # html comments only
        NA
      }else{ # urls and emails only
        x |>
          stringr::str_replace("^<", "") |>
          stringr::str_replace(">$", "")
      }
    }else{
      x
    }      
  }
}

#' Internal function to clean EML headings that behave oddly
#' @noRd
#' @keywords Internal
clean_eml_tags <- function(df){
  # modify the tibble to the required conventions for list/xml
  # `label` should be camel case
  df |>
    dplyr::mutate(label = snakecase::to_lower_camel_case(.data$label)) |>
    dplyr::mutate(label = dplyr::case_when(label == "Eml" ~ "eml",
                                           label == "surname" ~ "surName",
                                           label == "pubdate" ~ "pubDate",
                                           .default = label))
}