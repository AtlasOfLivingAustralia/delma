#' Convert ecological metadata from markdown to xml
#' 
#' @description
#' `{elm}` is a package to convert markdown documents to xml and back.
#' 'elm' is the common name for the genus 'Ulmus', which is a common tree in the 
#' Northern Hemisphere. It is also an anagram of 'EML', which is an acronym for
#' Ecological Meta Language, the format that this package creates.
#' 
#' @name elm-package
#' @docType package
#' @references If you have any questions, comments or suggestions, please email
#' [support@ala.org.au](mailto:support@ala.org.au).
#'
#' @section Functions:
#' **Example data**
#'   * [metadata_example]
#'   * [add_eml_header()] - add an 'EML' header row to a `tibble`
#'   * [use_metadata()]
#'   * [check_eml()]
#'   
#' **Low-level functions**
#'   * [parse_chr_to_tibble()]
#'   * [parse_tibble_to_list()]
#'   * [parse_list_to_xml()]
#'   * [parse_xml_to_list()]
#'   * [parse_list_to_tibble()]
#'   * [parse_tibble_to_chr()]
#' 
#' **Intermediate-level functions**
#'   * [as_eml_chr()] - convert to class `character`
#'   * [as_eml_tibble()] - convert to class `tbl_df` (i.e. a tibble)
#'   * [as_eml_list()] - convert to class `list`
#'   * [as_eml_xml()] - convert to class `xml_document`
#'
#' **Top-level functions**
#'   * [read_eml()] read EML from an `xml` file
#'   * [read_md()] read a markdown file
#'   * [write_eml()] write an object to `xml`
#'   * [write_md()] write an object to markdown
#'   
#' @keywords internal
"_PACKAGE"
