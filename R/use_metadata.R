#' Write an example metadata statement to disk
#' 
#' This function places a metadata template at the address specified by `"file"`,
#' defaulting to `"metadata.Rmd"` in the working directory. The template is 
#' built in such a way that standard rendering with `rmarkdown` or Quarto to
#' HTML or PDF will function; but also that it renders to valid EML using
#' [render_metadata()]. 
#' @param file (string) A name for the resulting file, with either `.Rmd` or
#' `.Qmd` as a suffix.
#' @param overwrite (logical) Should any existing file be overwritten? Defaults
#' to `FALSE`.
#' @export
use_metadata <- function(file = "metadata.Rmd",
                         overwrite = FALSE){
  
  # check format
  format <- stringr::str_extract(file, "\\.[:alnum:]+$")
  if(!(format %in% c(".Rmd", ".Qmd"))){
    bullets <- c(
      "Accepted file suffixes are `.Rmd` and `.Qmd`",
      i = glue::glue("Please rename `{file}` and try again"))
    rlang::abort(bullets)
  }
  
  # get `metadata_example.Rmd` and move it to the specified file name
  # NOTE: This works because Rmarkdown and Quarto documents
  # can be formatted identically. If they vary, we will need to ship
  # separate versions of `metadata_example`
  source_file <- system.file("extdata", 
                             "metadata_example.Rmd",
                             package = "delma")
  if(file.exists(file) & !overwrite){
    bullets <- c(glue::glue("file `{file}` already exists and has not been overwritten"),
                            i = "set `overwrite = TRUE` to change this behaviour")
    rlang::inform(bullets)
  }else{
    file.copy(from = source_file,
              to = file,
              overwrite = overwrite) |>
      invisible()    
  }
}