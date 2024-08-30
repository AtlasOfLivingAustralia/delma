#' @rdname parse_
#' @order 3
#' @importFrom xml2 as_xml_document
#' @export
parse_list_to_xml <- function(x){
  # type check
  if(!inherits(x, "list")){
    abort("`parse_chr_to_tibble()` only works on objects of class `list`")
  }
  
  x |>
    list_to_xml_recurse() |>
    append_attributes(full = x) |>
    as_xml_document()
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