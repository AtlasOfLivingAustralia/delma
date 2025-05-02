#' Convert metadata between markdown and EML
#' 
#' @description
#' Ecological Metadata Language (EML) is a common 
#' framework for describing ecological datasets so they can be shared and reused. 
#' `delma` supports users to write metadata statements in R Markdown or Quarto 
#' Markdown for greater transparency and ease-of-use, then convert them to 
#' EML for efficient transfer.
#' 
#' @name delma-package
#' @docType package
#' @references If you have any questions, comments or suggestions, please email
#' [support@ala.org.au](mailto:support@ala.org.au).
#'
#' @section Functions:
#' 
#' **Main functions**
#'   * [use_metadata_template()] - Create a template boilerplate metadata statement
#'   * [read_eml()]/[write_eml()] - Read / write EML files to a `tibble`
#'   * [read_md()]/[write_md()] - Read / write Rmd or qmd files to a `tibble`
#'   * [check_metadata()] - Run checks on an EML document
#'   
#' **Format manipulation**
#'   * [as_lp_tibble()] - Convert metadata to class a `tibble` (class `tbl_lp`)
#'   * [as_eml_tibble()] - Convert metadata to class a `tibble` (class `tbl_df`)
#'   * [as_eml_list()] - Convert metadata to class `list`
#'   * [as_eml_xml()]- Convert metadata to class `xml_document`
#'   
#' @keywords internal
"_PACKAGE"
