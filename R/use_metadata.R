#' Write an example metadata statement to disk
#' 
#' This function places a metadata template at the address specified by `"file"`,
#' defaulting to `"metadata.Rmd"` in the working directory. The template is 
#' built in such a way that standard rendering with `rmarkdown` or Quarto to
#' HTML or PDF will function; but also that it renders to valid EML using
#' [render_metadata()]. 
#' @param file (string) A name for the resulting file
#' @param format (string) What format should the metadata statement take?
#' Should be one of either "Rmd" (default) or "Qmd".
#' @param overwrite (logical) Should any existing file be overwritten? Defaults
#' to `FALSE`.
#' @export
use_metadata <- function(file = "metadata.Rmd",
                         format = c("Rmd", "Qmd"),
                         overwrite = FALSE){
  format <- match.arg(format)
  source_file <- system.file("extdata", 
                             switch(format,
                                    "Rmd" = "metadata_example.Rmd", 
                                    "Qmd" = "metadata_exmaple.Qmd"),
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