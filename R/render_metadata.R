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
#' @returns Does not return an object; called for the side-effect of rendering
#' a file to EML.
#' @export
render_metadata <- function(input,
                            output_file = NULL,
                            output_dir = NULL){
  if(missing(input)){
    bullets <- c("No `input` provided",
                 i = "Please provide a metadata file",
                 i = "You can call`use_metadata()` to create one")
    rlang::abort(bullets)
  }
  
  # create file name
  # NOTE: This is too basic at present, as either could be NULL
  output_string <- glue("{output_dir}/{output_file}")
  
  # render  
  read_md(input) |>
    write_eml(file = output_string)
}