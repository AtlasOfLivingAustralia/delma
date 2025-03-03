#' Write a markdown-formatted metadata document
#' 
#' @param x Object of any class handled by `delma`; i.e. `tbl_df`, `list` or 
#' `xml_document`.
#' #' @param file Filename to write to. Must be either `.md`, `.Rmd`
#' or `.Qmd` file.
#' @details
#' Similar to [read_md()], [write_md()] is considerably less generic than most 
#' `write_` functions. If `x` is an `xml_document` this should convert seamlessly;
#' but lists or tibbles that have been manually formatted require care. To parse 
#' correctly, the supplied `tibble` **must** contain the columns supplied by [read_md()].
#' 
#' Internally, `write_md()` calls [lightparser::combine_tbl_to_file].
#' @export
write_md <- function(x, file){
  
  # stop if file suffix is incorrect
  check_is_single_character(file)
  # if(!grepl(".md$", file)){
  #   abort("`write_md()` only writes files with a `.md` suffix.")
  # }
  
  # check for correct format
  if(!inherits(x, "tbl_df")){
    x <- as_eml_tibble(x)
  }
  
  # comparison tibble: 
  # df <- lightparser::split_to_tbl("EXAMPLE.Rmd")
  
  # challenge here is to arrange the tibble as carefully as possible
  # browser() # up to here
  
  x |>
    use_lightparser_format() |>
    # remove_eml_header() |> # this should probably change to something
    # that parses the eml attributes code section properly
    lightparser::combine_tbl_to_file(output_file = file)
}


#' Internal function to expand a tibble to format required by 
#' `combine_tbl_to_file`. Call `split_to_tbl` to see an example.
#' @noRd
#' @keywords Internal
use_lightparser_format <- function(x){
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
  
  # add `eml:eml` attributes as code block
  
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

#' Internal function to build a `yaml` row from existing data
#' @noRd
#' @keywords Internal
format_eml_block <- function(x){
  # browser()
  x[-which(x$heading == "eml:eml"), ] # temporary
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
  result$text[1] <- NA # doesn't work with `add_row()`
  result$code[1] <- NA # for some reason
  result
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