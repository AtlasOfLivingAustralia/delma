#' @rdname parse_
#' @order 6
#' @export
parse_tibble_to_chr <- function(x){
  # type check
  if(!inherits(x, c("md_tibble", "tbl_df"))){
    abort("`parse_chr_to_tibble()` only works on objects of class `md_tibble` or `tbl_df`")
  }
  
  rows <- nrow(x)
  y <- split(x, seq_len(rows))
  result <- map(.x = y,
                .f = \(a){
                  c(format_md_header(a), 
                    format_md_text(a$text))
                }) |>
    unlist()
  names(result) <- NULL
  class(result) <- c("md_chr", "character")
  result
}

#' Internal function called only by `parse_tibble_to_md()`
#' @noRd
#' @keywords Internal 
format_md_header <- function(a){
  if(is.na(a$attributes)){
    hashes <- strrep("#", a$level)
    glue("{hashes} {a$label}")
  }else{
    z <- a$attributes[[1]]
    attributes <- paste(names(z), z, sep = "=") |>
      paste(collapse = " ")
    glue("<h{a$level} {attributes}>{a$label}</h{a$level}>")
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