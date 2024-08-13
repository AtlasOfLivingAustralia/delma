#' @rdname parse_
#' @order 4
#' @param x an R object of the requisite type. No type checking is done.
#' @importFrom xml2 as_list
#' @export
parse_xml_to_list <- function(x)
{
  # type check
  if(!inherits(x, c("md_xml", "xml_document"))){
    abort("`parse_chr_to_tibble()` only works on objects of class `md_xml` or `xml_document`")
  }
  
  x_list <- as_list(x)
  result <- x_list |>
    xml_to_list_recurse() |>
    append_attributes(full = x_list) 
  class(result) <- c("md_list", "list")
  result
}

#' Drill into list constructed from xml to ensure terminal nodes are correct
#' @importFrom purrr map
#' @noRd
#' @keywords Internal
xml_to_list_recurse <- function(x){
  map(.x = x,
      .f = \(a){
        if(is.list(a)){
          if(length(a) == 1){
            if(inherits(a[[1]], "character")){
              a[[1]]
            }else{
              xml_to_list_recurse(a)
            }
          }else{
            xml_to_list_recurse(a)
          }
        }else{
          a[[1]]
        }
      })
}