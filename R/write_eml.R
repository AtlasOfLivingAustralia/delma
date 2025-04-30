#' Write an EML-formatted metadata document
#' 
#' `write_eml()` writes a `tibble`, `list` or `xml_document` to an EML file. 
#' Note that EML files always have the file extension `.xml`.
#' @param x Object of any class handled by `delma`; i.e. `tbl_df`, `list` or 
#' `xml_document`.
#' @param file Filename to write to
#' @returns Desn't return anything; called for the side-effect of writing the 
#' specified EML file to disk
#' @examples \dontrun{
#' use_metadata_template("example.Rmd") 
#' df <- read_md("example.Rmd")
#' write_eml(df, "example.xml")
#' }
#' @export
write_eml <- function(x, 
                      file){
  # check for correct format
  if(inherits(x, c("tbl_df", "list"))){
    x <- as_eml_xml(x)
  }
  
  # stop if not converted
  if(!inherits(x, "xml_document")){
    c("`write_eml()` only accepts objects of class `xml_document`.",
      i = "Use `as_eml_xml()` to convert it.") |>
    cli::cli_abort()
  }
  
  # stop if file suffix is incorrect
  check_is_single_character(file)
  if(!grepl(".xml$", file)){
    cli::cli_abort("`write_eml()` only writes files with a `.xml` suffix.")
  }
  
  # write out
  xml2::write_xml(x, 
                  file, 
                  options = list("format", "as_xml"))
}
