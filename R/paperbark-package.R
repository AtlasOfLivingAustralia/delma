#' Convert metadata between markdown and EML
#' 
#' @description
#' Ecological Meta Language is a common framework for describing ecological 
#' datasets so they can be shared and reused. `paperbark` supports users to 
#' write metadata statements in markdown for greater transparency and 
#' ease-of-use, then convert them to EML for efficient transfer.
#' 
#' @name paperbark-package
#' @docType package
#' @references If you have any questions, comments or suggestions, please email
#' [support@ala.org.au](mailto:support@ala.org.au).
#'
#' @section Functions:
#' 
#' **Basic usage**
#'   * [read_eml()]/[write_eml()] - Convert between EML and tibbles
#'   * [read_md()]/[write_md()] - Convert between markdown files and tibbles
#'   * [check_eml()] - Check your metadata statement against relevant standards
#'   
#' **Type conversion**
#'   * [as_eml_chr()] - Convert metadata to class `character`
#'   * [as_eml_tibble()] - Convert metadata to class `tbl_df` (i.e. a tibble)
#'   * [as_eml_list()] - Convert metadata to class `list`
#'   * [as_eml_xml()] - Convert metadata to class `xml_document`
#'   
#' @keywords internal
"_PACKAGE"
