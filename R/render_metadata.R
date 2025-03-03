#' Render a metadata statement to EML
#' 
#' Basically an expanded version of [rmarkdown::render]/[quarto::quarto_render]
#' to convert a metadata statement to EML. Note that this process ignores
#' the `output` section of the supplied `yaml`, though that should still be
#' supplied for rendering via other packages. Internally this function wraps
#' [read_md()] and [write_eml()] in that order; see those functions for details.
#' @param input A file to be rendered to EML
#' @param output_file The name of the output file
#' @param output_dir The output directory for the rendered `output_file`
#' @param overwrite (logical) Should any existing file be overwritten? Defaults
#' to `TRUE`.
#' @returns Does not return an object; called for the side-effect of rendering
#' a file to EML.
#' @export
render_metadata <- function(input,
                            output_file = NULL,
                            output_dir = NULL,
                            overwrite = TRUE){
  if(missing(input)){
    bullets <- c("No `input` provided",
                 i = "Please provide a metadata file",
                 i = "You can call`use_metadata()` to create one")
    rlang::abort(bullets)
  }

  # create file name
  # NOTE: This is too basic at present, as either could be NULL
  if(is.null(output_file)){
    output_file <- "meta.xml"  
  }
  
  # create file string, including path
  if(is.null(output_dir)){
    output_string <- output_file
  }else{
    output_string <- glue::glue("{output_dir}/{output_file}")  
  }
  
  if(file.exists(output_string) & !overwrite){
    bullets <- c(glue::glue("file `{file}` already exists and has not been overwritten"),
                 i = "set `overwrite = TRUE` to change this behaviour")
    rlang::inform(bullets)
  }else{
    # render  
    read_md(input) |>
      write_eml(file = output_string)  
  }

}