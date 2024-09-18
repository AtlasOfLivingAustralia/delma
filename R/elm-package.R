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
#' **Reading and writing**
#' 
#'   * [read_elm()] import markdown or `xml` to a `tibble`
#'   * [write_elm_chr()] write an `elm` object to markdown
#'   * [write_elm_xml()] write an `elm` objects to xml
#'   
#' **Type Conversion**
#'
#'   * [as_elm_chr()] - convert to class `character`
#'   * [as_elm_tibble()] - convert to class `tbl_df` (i.e. a tibble)
#'   * [as_elm_list()] - convert to class `list`
#'   * [as_elm_xml()] - convert to class `xml_document`
#'   * [add_elm_header()] - add an 'EML' header row to a `tibble`
#'   
#' **Parsers**
#'   * [parse_chr_to_tibble()]
#'   * [parse_tibble_to_list()]
#'   * [parse_list_to_xml()]
#'   * [parse_xml_to_list()]
#'   * [parse_list_to_tibble()]
#'   * [parse_tibble_to_chr()]
#'  
#' @keywords internal
"_PACKAGE"
