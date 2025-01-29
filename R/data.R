#' Example metadata statement
#'
#' This is a very minimalist metadata statement, stored as a tibble, that you
#' can adapt for your own purposes.
#'
#' @format ## `metadata_example`
#' A tibble with X rows and 4 columns, where each row is an xml heading:
#' \describe{
#'   \item{level}{integer: Nestedness level}
#'   \item{label}{character: xml tag}
#'   \item{text}{list-colum: may contain `NA` for no content, or any type of vector
#'   that can be manipulated to a string. Where the entry is a list, list-entries 
#'   are treated as separate paragraphs.}
#'   \item{attributes}{list-column: xml attributes. Entries should either be `NA` 
#'   or a named list.}
#' }
#' @source ALA
"metadata_example"