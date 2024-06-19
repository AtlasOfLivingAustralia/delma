#' @rdname as_eml
#' @order 4
#' @importFrom xml2 as_list
#' @exportS3Method elm::as_eml
as_eml.xml_document <- function(x, ...){
  x_list <- x |> as_list()
  result <- x_list |>
    xml_to_list_recurse() |>
    append_attributes(full = x_list)   
  class(result) <- c("eml", "list")
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