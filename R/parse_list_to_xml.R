#' @rdname parse_
#' @order 3
#' @importFrom xml2 as_xml_document
#' @export
parse_list_to_xml <- function(x){
  # type check
  if(!inherits(x, c("md_list", "list"))){
    abort("`parse_chr_to_tibble()` only works on objects of class `md_list` or `list`")
  }
  
  result <- x |>
    eml_to_xml_recurse() |>
    append_attributes(full = x) |>
    as_xml_document()
  class(result) <- c("md_xml", "xml_document", "xml_node")
  result
}

#' Drill into list constructed from xml to ensure terminal nodes are correct
#' @importFrom purrr map
#' @noRd
#' @keywords Internal
list_to_xml_recurse <- function(x){
  map(.x = x,
      .f = \(a){
        if(is.list(a)){
          list_to_xml_recurse(a)
        }else{
          list(a)
        }
      })
}