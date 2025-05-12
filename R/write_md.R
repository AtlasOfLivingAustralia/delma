#' Write a markdown-formatted metadata document
#' 
#' @description
#' `write_md()` creates an `Rmd` or `Qmd` file from an EML file.
#' @param x Object of any class handled by `delma`; i.e. `tbl_lp,` `tbl_df`, 
#' `list` or `xml_document`.
#' @param file Filename to write to. Must be either `.md`, `.Rmd`
#' or `.qmd` file.
#' @details
#' Similar to [read_md()], [write_md()] is considerably less generic than most 
#' `write_` functions. If `x` is an `xml_document` this should convert seamlessly;
#' but lists or tibbles that have been manually formatted require care. 
#' Internally, `write_md()` calls [lightparser::combine_tbl_to_file].
#' @returns Doesn't return anything; called for the side-effect of writing the 
#' specified markdown file to disk.
#' @examples
#' \dontshow{
#' .old_wd <- setwd(tempdir())
#' }
#' source_file <- system.file("extdata", 
#'                            "bionet_metadata.xml",
#'                            package = "delma")
#' df <- read_eml(source_file)
#' write_md(df, "example.Rmd")
#' \dontshow{
#' setwd(.old_wd)
#' }
#' @export
write_md <- function(x, file){

  check_is_single_character(file)
  check_valid_suffix(file)
  
  x |>
    as_lp_tibble() |>
    lightparser::combine_tbl_to_file(output_file = file)
}