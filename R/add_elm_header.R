#' Add EML header to a `tibble`
#' 
#' This function adds standard EML information to a tibble, such that when 
#' it is converted to xml, it parses correctly as EML. This is not applied 
#' as standard by `as_elm_xml()` because it is plausible that some (many?) 
#' users may not wish their files to be interpretable as EML.
#' @param x Object of class `md_tibble`
#' @importFrom dplyr mutate
#' @importFrom rlang .data
#' @importFrom tibble add_row
#' @export
add_elm_header <- function(x){
  if(!inherits(x, "tbl_df")){
    abort("add_eml() requires an object of class `tbl_df`")
  }
  
  # if `attributes` list-column is missing, add it (with NA for each entry)
  if(!any(colnames(x) == "attributes")){
    x$attributes <- rep(NA, nrow(x)) |>
      as.list()
  }
  
  # If first entry says "eml", overwrite with correct info
  if(grepl("eml|EML", x$label[[1]])){
    x$level <- 1
    x$label[[1]] <- "eml:eml"
    x$attributes[[1]] <- eml_attributes()
  # otherwise, add a new row with eml info
  }else{
    if(min(x$level) == 1){
      x <- mutate(level = .data$level + 1)
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
    `xsi:schemaLocation` = "eml://ecoinformatics.org/eml-2.1.1 http://rs.gbif.org/schema/eml-gbif-profile/1.1/eml-gbif-profile.xsd",
    `xml:lang` = "en"
    )
  )
}
