#' Parse objects from one class to another
#'
#' These low-level functions are primarily built to be called by the various 
#' `as_md` functions, but are exported for greater transparency and bug-fixing.
#' @name parse_
#' @order 1
#' @param x An R object of the requisite type.
#' @importFrom dplyr any_of
#' @importFrom dplyr arrange
#' @importFrom dplyr bind_rows
#' @importFrom dplyr mutate
#' @importFrom dplyr select
#' @importFrom rlang .data
#' @noRd
#' @keywords Internal
parse_chr_to_tibble <- function(x){
  # find titles, in either `<h1>` or `#` format
  title_check <- grepl("^\\s*(#|<h[[:digit:]])", x)
  
  # get html headers first
  equals_check <- grepl("=", x) & title_check # note: can only happen with `<hn>` structure
  # also note: we subset after checking so the index is to x, not x[title_check]
  # code for seeking end of header in hn format
  tibble1 <- get_header_label_html(x, which(equals_check))
  
  # then markdown headers
  markdown_check <- grepl("^#+", x) & title_check
  tibble2 <- get_header_label_md(x, which(markdown_check))
  
  # join and order
  result <- bind_rows(tibble1, tibble2) |>
    arrange(.data$start_row) |>
    get_md_text(x) |>
    select(any_of(c("level", "label", "text", "attributes")))
  
  if(check_for_jump_levels(result$level)){
    abort(c("`level` variable includes jumps (increases > 1)", 
            i = "Please ensure that nesting levels only ever increase by 1"))
  }else{
    result
  }
}

#' Internal function to find bugs in levels
#' @noRd
#' @keywords Internal
check_for_jump_levels <- function(x){
  any((x - dplyr::lag(x)) > 1, na.rm = TRUE)
}

#' get header attributes when formatted as ##Header
#' @importFrom dplyr bind_rows
#' @importFrom purrr map
#' @importFrom stringr str_remove
#' @importFrom tibble tibble
#' @noRd
#' @keywords Internal
get_header_label_md <- function(string, rows){
  if(length(rows) < 1){
    NULL
  }else{
    tibble(
      start_row = rows,
      end_row = rows, 
      level = {regexpr("^#{1,}", string[rows]) |>
          attr("match.length")},
      label = str_remove(string[rows], "^#+\\s*"),
      attributes = list(NA)
    )    
  }
}

#' get header attributes when formatted as <h1> etc
#' @importFrom dplyr bind_rows
#' @importFrom purrr map
#' @noRd
#' @keywords Internal
get_header_label_html <- function(string, rows){
  if(length(rows) < 1){
    NULL
  }else{
    map(.x = seq_along(rows),
        .f = function(i){extract_header_html(i, rows, string)}) |>
      bind_rows()    
  }
}

#' Internal function to parse each section as xml
#' @importFrom glue glue
#' @importFrom glue glue_collapse
#' @importFrom stringr str_extract
#' @importFrom stringr str_remove
#' @importFrom tibble as_tibble
#' @importFrom tibble tibble
#' @importFrom xml2 xml_text
#' @importFrom xml2 read_xml
#' @noRd
#' @keywords Internal
extract_header_html <- function(i, rows, string){
  xx <- rows[i]
  # work out header level
  level <- str_extract(string[xx], "<h[[:digit:]]{1}") |>
    str_remove("<")
  # get closing row
  which_close <- grepl(glue("</{level}>"), string) |>
    which()
  # get vector of rows to collapse together
  row_close <- min(which_close[which_close >= xx])
  lookup <- seq(from = xx, to = row_close)
  temp_string <- glue_collapse(string[lookup])
  # use xml to parse string
  result_xml <- read_xml(temp_string)
  tibble(
    start_row = xx,
    end_row = row_close,
    level = as.integer(str_extract(level, "[:digit:]")),
    label = xml_text(result_xml),
    attributes = get_xml_attrs(result_xml))
}

#' Internal function to parse xml attributes correctly
#' @importFrom purrr map
#' @importFrom xml2 xml_attrs
#' @noRd
#' @keywords Internal
get_xml_attrs <- function(x){
  result <- x |>
    xml_attrs() |>
    as.list()
  if(length(result) < 1){
    list() # empty list for no attributes: Q should this be NA?
  }else{
    map(result, 
        \(y){
          if(y == "\\"){
            "\\\""
          }else{
            y
          }
        }) |>
      list() 
  }
}

#' Internal function to find text rows and assign them correctly
#' TODO: Support internal paragraph breaks
#' @importFrom glue glue_collapse
#' @importFrom purrr map
#' @importFrom rlang .data
#' @importFrom stringr str_replace
#' @importFrom tibble tibble
#' @noRd
#' @keywords Internal
get_md_text <- function(df, string){
  # n_rows <- nrow(df)
  text_df <- tibble(
    start = df$end_row + 1,
    end = c(df$start_row[-1] - 1, length(string))) |>
    mutate(row_length = .data$end - .data$start)
  
  # this needs to return a list column
  # list entries must have the option of being split by paragraph breaks
  text <- map(  
    .x = split(text_df, seq_len(nrow(text_df))),
    .f = \(i){
      if(i$row_length < 0){
        NA
      }else if(i$row_length == 0){
        x <- string[seq(i$start, i$end)]
        if(x == ""){
          NA
        }else{
          x |>
            trimws() |>
            str_replace("\\s{2,}", "\\s")
        }
      }else{
        x <- string[seq(i$start, i$end)]
        while(x[length(x)] == ""){x <- x[-length(x)]}
        if(any(x == "")){
          x[x == ""] <- "{BREAKPOINT}"
          glue_collapse(x, sep = " ") |>
            strsplit(split = "\\{BREAKPOINT\\}") |>
            purrr::pluck(!!!list(1)) |>
            trimws() |>
            str_replace("\\s{2,}", "\\s") |>
            as.list()
        }else{
          glue_collapse(x, sep = " ") |>
            as.character()
        }
      }
    })

  df |>
    dplyr::mutate(text = unname(text))
}