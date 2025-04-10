#' Write a markdown-formatted metadata document
#' 
#' @param x Object of any class handled by `delma`; i.e. `tbl_lp,` `tbl_df`, 
#' `list` or `xml_document`.
#' @param file Filename to write to. Must be either `.md`, `.Rmd`
#' or `.Qmd` file.
#' @details
#' Similar to [read_md()], [write_md()] is considerably less generic than most 
#' `write_` functions. If `x` is an `xml_document` this should convert seamlessly;
#' but lists or tibbles that have been manually formatted require care.
#' 
#' Internally, `write_md()` calls [lightparser::combine_tbl_to_file].
#' @examples \dontrun{
#' df <- read_eml("https://collections.ala.org.au/ws/eml/dr368")
#' write_eml(df, "example.xml")
#' }
#' @export
write_md <- function(x, file){

  check_is_single_character(file)
  check_valid_suffix(file)
  
  x |>
    as_lp_tibble() |>
    lightparser::combine_tbl_to_file(output_file = file)
}