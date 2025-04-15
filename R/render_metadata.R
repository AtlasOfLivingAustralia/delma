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
#' @param overwrite (logical) Should any existing file be overwritten? Default is set
#' to `FALSE`.
#' @param quiet (logical) Should messages be suppressed? Default is set to `FALSE`.
#' @returns Does not return an object; called for the side-effect of rendering
#' a file to EML.
#' @examples \dontrun{
#' use_metadata_template("example.Rmd") 
#' # assume the user edits the file, then calls:
#' render_metadata("example.Rmd", output_file = "example.xml")
#' }
#' @export
render_metadata <- function(input,
                            output_file = NULL,
                            output_dir = NULL,
                            overwrite = FALSE,
                            quiet = FALSE){
  if(missing(input)){
    c("No metadata file provided.",
      i = "You can call `use_metadata_template()` to create one.") |>
      cli::cli_abort()
  }
  # cli::cli_progress_step("Converting {.file {input}} to EML.")
  cli::cli_alert_info("Converting {.file {input}} to EML")
  for(i in 1:100) {
    Sys.sleep(0.001) # wait
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

  # write or not, depending on `overwrite`
  if(file.exists(output_string)){
    if(overwrite){
      if(!quiet){
        c("Overwriting {.file {output_string}}.") |>
        cli::cli_progress_step()
      }
      read_md(input) |> 
        write_eml(file = output_string) 
    }else{
      if(!quiet){
        c("File {.file {output_string}} already exists.",
          i = "Set `overwrite = TRUE` to overwrite this file.") |>
        cli::cli_warn()
      }
    }
  }else{
    if(!quiet){
      # c("Writing {.file {output_string}}") |>
      #   cli::cli_progress_step(spinner)
      for (i in cli::cli_progress_along(1:100, "Converting")) {
        Sys.sleep(5/100)
      }
      md_output <- read_md(input) 
      cli::cli_progress_done()
      
      cli::cli_progress_step("Writing {.file {output_string}}.")
      md_output |> 
        write_eml(file = output_string)
      
    } else {
      read_md(input) |>
        write_eml(file = output_string)
    }
  }
}