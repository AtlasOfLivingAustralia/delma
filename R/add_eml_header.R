#' Add EML header to a `tibble`
#' 
#' This function adds standard EML information to a tibble, such that when 
#' it is converted to xml, it parses correctly as EML. This is not applied 
#' as standard by `as_eml_xml()` because it is possible that not all users will
#' want their files to be interpretable as EML.
#' @param x Object of class `md_tibble`
#' @details
#' If the first row of the supplied tibble contains the string `"eml"` or 
#' `"EML"`, then it will be overwritten by this function. Otherwise a new row is 
#' adding above all other rows.
#' 
#' Note that the attributes added to the eml header by this function are those 
#' expected by the Darwin Core standard, which is used routinely within the 
#' Global Biodiversity Information Facility (GBIF) and its' partner nodes. Other 
#' applications of EML may require different attributes.
#' @returns A tibble with a correctly formatted first row. 
#' @importFrom rlang .data
#' @noRd
#' @keywords Internal
add_eml_header <- function(x){
  if(!inherits(x, "tbl_df")){
    rlang::abort("`add_eml_header()` requires an object of class `tbl_df`")
  }
  
  # if `attributes` list-column is missing, add it (with NA for each entry)
  if(!any(colnames(x) == "attributes")){
    x$attributes <- rep(NA, nrow(x)) |>
      as.list()
  }
  
  # If first entry says "eml", overwrite with correct info
  if(grepl("eml|EML", x$label[[1]])){
    x <- x |>
      dplyr::slice(-1)
  # otherwise, add a new row with eml info
  }else{
    if(min(x$level) == 1){
      x <- x |>
        dplyr::mutate(level = .data$level + 1)
    }
  }
  x |>
    tibble::add_row(level = 1, 
                    label = "eml:eml", 
                    text = list(NA),
                    attributes = list(NA),
                    .before = 1)
}

#' Internal function to remove EML headers before rendering to markdown
#' 
#' Basically the inverse of add_eml_header().
#' @noRd
#' @keywords Internal
remove_eml_header <- function(x){
  if(!inherits(x, "tbl_df")){
    abort("remove_eml_header() requires an object of class `tbl_df`")
  }
  # If first entry says "eml", overwrite with correct info
  if(grepl("eml|EML", x$label[[1]])){
    x |>
      dplyr::slice(-1) |>
      dplyr::mutate(level = .data$level - 1)
  }else{
    x
  }
}