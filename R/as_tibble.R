#' Extension for `as_tibble` to class `xml_document`
#' 
#' In test
#' @export
as_tibble.xml_document <- function(x, ...){
  x |>
    xml2::as_list() |>
    parse_list_to_tibble()
}