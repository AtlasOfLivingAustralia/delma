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
#'   * [read_md()] to import from Markdown files
#'   * [read_xml()] to import from XML - reexported from `{xml2}`
#'   
#' **Type Conversion**   
#'
#'   * [as_md()] - markdown stored as strings
#'   * [as_tibble()] - tibbles (from package `{tibble}`)
#'   * [as_eml()] - listlike data
#'   * [as_xml()] - xml data
#'  
#' @keywords internal
"_PACKAGE"