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
#' **Top-level functions**
#'   * [read_eml()] - read EML from an `xml` file to a `tibble`
#'   * [read_md()] - read metadata from a markdown file to a `tibble`
#'   * [write_eml()] - write an object to `xml`
#'   * [write_md()] - write an object to markdown
#'   * [add_eml_header()] - add an 'EML' header row to a `tibble`
#'   * [check_eml()] - run checks of a file or object against relevant standards
#'   
#' **Intermediate-level functions**
#'   * [as_eml_chr()] - convert to class `character`
#'   * [as_eml_tibble()] - convert to class `tbl_df` (i.e. a tibble)
#'   * [as_eml_list()] - convert to class `list`
#'   * [as_eml_xml()] - convert to class `xml_document`
#'   
#' **Low-level functions**
#'   * [parse_chr_to_tibble()] - convert from `character` to `tibble`
#'   * [parse_tibble_to_list()] - convert from `tibble` to `list`
#'   * [parse_list_to_xml()] - convert from `list` to `xml_document`
#'   * [parse_xml_to_list()] - convert from `xml_document` to `list`
#'   * [parse_list_to_tibble()] - convert from `list` to `tibble`
#'   * [parse_tibble_to_chr()] - convert from `tibble` to `character`
#' 
#' **Example data**
#'   * [metadata_example] - a boilerplate metadata statement
#'   * [use_metadata()] - create a metadata statement as a markdown file
#'
#'   
#' @keywords internal
"_PACKAGE"
