#' @rdname read_md
#' @param x Object of any class handled by `delma`; i.e. `character`, 
#' `tbl_df`, `list` or `xml_document`.
#' @importFrom rlang abort
#' @importFrom xml2 write_xml
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
  
  # x |>
  #   remove_eml_header() |>
  #   as_eml_chr() |>
  #   writeLines(con = file)
  x |>
    lightparser::combine_tbl_to_file(output_file = file)
}
