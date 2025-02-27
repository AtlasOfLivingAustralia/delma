#' Convert metadata between markdown and EML
#' 
#' @description
#' Ecological Metadata Language is a common 
#' framework for describing ecological datasets so they can be shared and reused. 
#' `delma` supports users to write metadata statements in markdown for greater 
#' transparency and ease-of-use, then convert them to EML for efficient transfer.
#' 
#' @name delma-package
#' @docType package
#' @references If you have any questions, comments or suggestions, please email
#' [support@ala.org.au](mailto:support@ala.org.au).
#'
#' @section Functions:
#' 
#' **Main functions**
#'   * [use_metadata()] - Create a boilerplate metadata statement
#'   * [render_metadata()] - Render metadata as an EML document
#'   * [check_metadata()] - Run checks on an EML document
#' 
#' **Data manipulation** 
#'   * [read_eml()]/[write_eml()] - Read / write EML files to `tbl_df`
#'   * [read_md()]/[write_md()] - Read / write Rmd or Qmd files to `tbl_df`
#'   * [as_eml()] - Convert metadata from class `tbl_df` to class `xml_document`
#'   * [as_tibble.xml_document()] - Convert metadata from class `xml_document` to class `tbl_df`
#'   
#' @keywords internal
"_PACKAGE"
