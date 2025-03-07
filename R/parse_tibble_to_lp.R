#' Internal function to parse lightparser to delma format
#' @noRd
#' @keywords Internal
parse_tibble_to_lp <- function(x){
  empty_character <- rep(NA, nrow(x)) |>
    as.character()
  x |>
    dplyr::rename("heading" = "label",
                  "heading_level" = "level") |>
    dplyr::mutate("section" = .data$heading,
                  "params" = list(NA),
                  "code" = list(NA), 
                  "label" = empty_character,
                  "type" = empty_character,
                  heading_level = heading_level - 1) |>
    
    # add `eml:eml` attributes as code block (or just `eml`??)
    
    collapse_text() |> # convert list-entries in text to single vectors
    expand_text_rows() |> # expand out text to put heading and text on sequential rows
    dplyr::select("type", "label", "params", "text", "code", 
                  "heading", "heading_level", "section") |>
    rebuild_yaml() |> # add yaml from title, date
    format_eml_block()
  # browser()
  # Set code block content
  # convert `attributes` to list-code in `code` column
  # add block `label` to `params` column AND `label` column
}

#' Internal function to collapse text from list-format to character vectors
#' @noRd
#' @keywords Internal
collapse_text <- function(x){
  result <- purrr::map(x$text, 
                       \(a){
                         xx <- purrr::map(a, \(b){
                           c(b, "")
                         }) |>
                           unlist()
                         c(xx[!is.na(xx)], "")
                       })
  x$text <- result
  x
}

#' Internal function to split rows with header and text on same row to 
#' separate rows.
#' @noRd
#' @keywords Internal
expand_text_rows <- function(x){
  x_list <- split(x, seq_len(nrow(x)))
  purrr::map(x_list, 
             \(a){
               if(is.character(a$text[[1]])){
                 b <- tibble::add_row(a)
                 b$text[2] <- b$text[1]
                 b$text[1] <- format_header(a[1, ])
                 b$type <- c("heading", "inline")
                 b$section[2] <- b$section[1]
                 b$attributes[2] <- b$params[2] <- b$code[2] <- NA
                 b
               }else{
                 b <- a
                 b$type <- "heading"
                 b$text <- format_header(a)
                 b
               }
             }) |>
    dplyr::bind_rows()
}

#' Internal function to format markdown-style headers
#' @noRd
#' @keywords Internal
format_header <- function(df){
  if(df$heading_level > 0){
    hashes <- strrep("#", df$heading_level)
    heading <- df$heading
    glue::glue("{hashes} {heading}") |>
      as.character() |>
      list()
  }else{
    NA
  }
}

#' Internal function to build a `yaml` row from existing data
#' @noRd
#' @keywords Internal
rebuild_yaml <- function(x){
  # get title
  title_row <- x$section == "Title" & !is.na(x$text)
  if(any(title_row)){
    yaml_title <- x$text[which(title_row)[2]] 
  }else{
    yaml_title <- "unknown"
  }
  # get date
  date_row <- x$section == "Pubdate" & !is.na(x$text)
  if(any(date_row)){
    yaml_date <- x$text[which(date_row)[2]] 
  }else{
    yaml_date <- NULL
  }
  result <- x |>
    tibble::add_row("params" = list(list(title = yaml_title,
                                         date = yaml_date)),
                    "type" = "yaml",
                    .before = 1)
  result$text[1] <- NA # doesn't work with `add_row()` for some reason
  result$code[1] <- NA # ditto
  result
}

#' Internal function to build a `yaml` row from existing data
#' @noRd
#' @keywords Internal
format_eml_block <- function(x){
  # browser()
  x[-which(x$heading == "eml:eml"), ] # temporary
}