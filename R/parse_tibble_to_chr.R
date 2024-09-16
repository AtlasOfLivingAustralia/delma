#' @rdname parse_
#' @order 6
#' @export
parse_tibble_to_chr <- function(x){
  # type check
  if(!inherits(x, "tbl_df")){
    abort("`parse_chr_to_tibble()` only works on objects of class `tbl_df`")
  }
  # split apply recombine
  rows <- nrow(x)
  y <- split(x, seq_len(rows))
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
    glue("{hashes} {a$label}")
  }else{
    z <- a$attributes[[1]]
    if(length(z) < 1){
      hashes <- strrep("#", a$level)
      glue("{hashes} {a$label}")
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
      glue("<h{a$level} {attributes}>{a$label}</h{a$level}>")
    }
  }
}

#' Internal function called only by `parse_tibble_to_md()`
#' @noRd
#' @keywords Internal 
format_md_text <- function(string){
  if(is.na(string)){
    ""
  }else{
    c("", string, "")
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