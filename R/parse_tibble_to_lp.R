#' Internal function to parse lightparser to delma format
#' @noRd
#' @keywords Internal
parse_tibble_to_lp <- function(x){
  # set up required content
  empty_character <- rep(NA, nrow(x)) |> as.character()
  # x_attr <- build_attributes_code(x)

  # rebuild tibble
  result <- x |>
    dplyr::rename("heading" = "label",
                  "heading_level" = "level") |>
    dplyr::mutate("section" = .data$heading,
                  "params" = list(NA),
                  "code" = list(NA), 
                  "label" = empty_character,
                  "type" = empty_character) |>
    clean_tbl_text_lp() |>
    build_attributes_code() |>
    dplyr::select("type", "label", "params", "text", "code", 
                  "heading", "heading_level", "section") |>
    rebuild_yaml() # add yaml from title, date
  
  # change class
  class(result) <- c("tbl_lp", "tbl_df", "tbl", "data.frame")
  result
}

#' Internal function to 
#' 1. detect 'attributes' in delma tibble
#' 2. convert those to list-code
#' 3. create a usable tibble to join with lightparser format
#' @noRd
#' @keywords Internal
build_attributes_code <- function(x){
  attr_rows <- which(!is.na(x$attributes))
  if(length(attr_rows) > 0){
    # build a tibble to contain required code
    result <- tibble::tibble(
      type = "block",
      label = x$heading[attr_rows],
      params = purrr::map(
        x$heading[attr_rows], 
        \(a){list(label = a, include = FALSE)}
      ),
      text = NA,
      code = purrr::map(x$attributes[attr_rows], convert_list_to_code),
      heading = NA,
      heading_level = NA,
      section = x$heading[attr_rows])
    # join each row in it's right place
    n_index <- seq_len(nrow(result))
    index_rows <- attr_rows + n_index - 1
    result_list <- split(result, n_index)
    final <- x
    for(i in n_index){
      final <- final |> 
        dplyr::add_row(result_list[[i]], .after = index_rows[i])
    }
    final
  }else{
    x
  }
}

#' Internal function to convert a list into code for itself
#' Assumes all entries are strings
#' @noRd
#' @keywords Internal
convert_list_to_code <- function(a){
  # format entries to list code
  list_entries <- glue::glue("  {tidy_names(a)} = \"{a}\",")
  
  # for the last entry, remove tailing `,`
  n <- length(list_entries)
  list_entries[n] <- stringr::str_replace(list_entries[n], 
                                          ",$", 
                                          "")
  c("list(", list_entries, ")")
}

#' Internal function to clean up list names
#' @noRd
#' @keywords Internal
tidy_names <- function(a){
  name_values <- names(a)
  punctuation_names <- stringr::str_detect(name_values, "[:punct:]")
  if(any(punctuation_names)){
    altered_names <- glue::glue("`{name_values[punctuation_names]}`")
    name_values[punctuation_names] <- altered_names
  }
  name_values
}

#' Internal function to clean tbl text to lp format
#' @noRd
#' @keywords Internal
clean_tbl_text_lp <- function(x){
  x |>
    collapse_text() |> # convert list-entries in text to single vectors
    expand_text_rows() # expand out text to put heading and text on sequential rows
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