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
#' **Reading and writing** 
#'   * [read_eml()]/[write_eml()] - Read / write EML files to `tbl_df`
#'   * [read_md()]/[write_md()] - Read / write Rmd or Qmd files to `tbl_df`
#'   
#' **Format manipulation**
#'   * [as_lp_tbl()] - Convert metadata to class `tbl_lp`
#'   * [as_eml_tbl()] - Convert metadata to class `tbl_df`
#'   * [as_eml_list()] - Convert metadata to class `list`
#'   * [as_eml_xml()]- Convert metadata to class `xml_document`
#'   
#' @keywords internal
"_PACKAGE"
