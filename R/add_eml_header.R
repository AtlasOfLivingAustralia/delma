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
#' @importFrom dplyr mutate
#' @importFrom rlang .data
#' @importFrom tibble add_row
#' @export
add_eml_header <- function(x){
  if(!inherits(x, "tbl_df")){
    abort("add_eml_header() requires an object of class `tbl_df`")
  }
  
  # if `attributes` list-column is missing, add it (with NA for each entry)
  if(!any(colnames(x) == "attributes")){
    x$attributes <- rep(NA, nrow(x)) |>
      as.list()
  }
  
  # If first entry says "eml", overwrite with correct info
  if(grepl("eml|EML", x$label[[1]])){
    x$level[[1]] <- 1
    x$label[[1]] <- "eml:eml"
    x$attributes[[1]] <- eml_attributes()[[1]]
  # otherwise, add a new row with eml info
  }else{
    if(min(x$level) == 1){
      x <- x |>
        mutate(level = .data$level + 1)
    }
    x <- x |>
      add_row(level = 1, 
              label = "eml:eml", 
              text = "",
              attributes = eml_attributes(),
              .before = 1)
  }
  return(x) 
}

#' Internal function to call standard EML attributes
#' @noRd
#' @keywords Internal
eml_attributes <- function(){
  list(
    list(
    `xmlns:d` = "eml://ecoinformatics.org/dataset-2.1.0",
    `xmlns:eml` = "eml://ecoinformatics.org/eml-2.1.1",
    `xmlns:xsi` = "http://www.w3.org/2001/XMLSchema-instance",
    `xmlns:dc` = "http://purl.org/dc/terms/",
    `xsi:schemaLocation` = "eml://ecoinformatics.org/eml-2.1.1 http://rs.gbif.org/schema/eml-gbif-profile/1.3/eml-gbif-profile.xsd",
     system = "R-paperbark-package",
     scope = "system",
    `xml:lang` = "en"
    )
  )
}
