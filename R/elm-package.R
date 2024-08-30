#' Convert ecological metadata from markdown to xml
#' 
#' @description
#' `{elm}` is in development. It is similar to `{emld}`, but with the goal of
#' seamlessly converting between markdown and R formats such as tibbles, lists,
#' and xml.
#' 
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
#'   * [read_md_chr()] import markdown as tibble
#'   * [read_md_xml()] import xml as tibble
#'   * [write_md_chr()] write an `elm` object to markdown
#'   * [write_md_xml()] write an `elm` objects to xml
#'   
#' **Type Conversion**   
#'
#'   * [as_md_chr()] - convert to class `character`
#'   * [as_md_tibble()] - convert to class `tbl_df` (i.e. a tibble)
#'   * [as_md_list()] - convert to class `list`
#'   * [as_md_xml()] - convert to class `xml_document`
#'   * [add_eml_row()] - add an 'EML' row to an object of class `tibble`
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