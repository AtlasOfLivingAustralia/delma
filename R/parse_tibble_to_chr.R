#' @rdname parse_
#' @order 6
#' @noRd
#' @keywords Internal
parse_tibble_to_chr <- function(x){
  # split apply recombine
  rows <- nrow(x)
  y <- x |>
    dplyr::mutate(double_line = level < dplyr::lag(.data$level)) |>
    split(f = seq_len(rows))
  y[[1]]$double_line <- FALSE
  
  map(.x = y,
      .f = \(a){
        c(format_md_header(a), 
          format_md_text(a$text))
      }) |>
    unlist() |>
    unname() |>
    clean_empty_headers()
}

#' Internal function called only by `parse_tibble_to_md()`
#' @importFrom glue glue
#' @importFrom glue glue_collapse
#' @importFrom purrr map
#' @noRd
#' @keywords Internal 
format_md_header <- function(a){
  if(is.na(a$attributes)){
    hashes <- strrep("#", a$level)
    result <- glue("{hashes} {a$label}")
  }else{
    z <- a$attributes[[1]]
    if(length(z) < 1){
      hashes <- strrep("#", a$level)
      result <- glue("{hashes} {a$label}")
    }else{
      z <- a$attributes[[1]]
      attributes <- map(seq_along(z),
                        .f = \(b){
                          contents <- z[[b]]
                          if(contents == "\""){
                            contents <- "\\\""
                          }
                          glue("{names(z)[b]}=\"{contents}\"")
                        }) |>
        unlist() |>
        glue_collapse(sep = " ")
      result <- glue("<h{a$level} {attributes}>{a$label}</h{a$level}>")
    }
  }
  if(a$double_line){
    c("", result)
  }else{
    result
  }
}

#' Internal function called only by `parse_tibble_to_md()`
#' @noRd
#' @keywords Internal 
format_md_text <- function(string){
  x <- string[[1]] # assuming all entries will be length-1; should be safe
  if(length(x) > 1){
    result <- map(x, \(a){c(a, "")}) |> unlist()
    c(result, "") # add extra line to prevent crowding
  }else{
    if(is.na(x)){
      ""  
    }else{
      c(x, "")
    }
  }
}

#' Internal function to remove headers from xml docs that render as "#### NA"
#' These need to be re-added during the inverse operation
#' @noRd
#' @keywords Internal 
clean_empty_headers <- function(a){
  empty_tags <- grepl("^(#+) NA", a)
  if(any(empty_tags)){
    empty_rows <- which(empty_tags)
    remove_rows <- sort(c(empty_rows, empty_rows + 1))
    a[!(seq_along(a) %in% remove_rows)]
  }else{
    a
  }
}