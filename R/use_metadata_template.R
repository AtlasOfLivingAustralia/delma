#' Write an example metadata statement to disk
#' 
#' @description
#' This function places a metadata template at the address specified by `"file"`,
#' defaulting to `"metadata.Rmd"` in the working directory. The template is 
#' built in such a way that standard rendering with `rmarkdown` or Quarto to
#' HTML or PDF will function; but also that it renders to valid EML using
#' [render_metadata()]. 
#' @param file (string) A name for the resulting file, with either `.Rmd` or
#' `.qmd` as a suffix. If `NULL` will default to `metadata.md`.
#' @param overwrite (logical) Should any existing file be overwritten? Defaults
#' to `FALSE`.
#' @param quiet (logical) Should messages be suppressed? Defaults to `FALSE`.
#' @returns Doesn't return anything to the workspace; called for the side-effect
#' of placing a metadata statement in the working directory.
#' @examples \dontrun{
#' use_metadata_template("example.Rmd") 
#' }
#' @export
use_metadata_template <- function(file = NULL,
                         overwrite = FALSE,
                         quiet = FALSE){
  if(is.null(file)){
    file <- "metadata.md"
  }
  if(!quiet){
    # cli::cli_progress_step("Creating template file")
    # cli::cli_progress_done()    
  }
  
  # check format
  format <- stringr::str_extract(file, "\\.[:alnum:]+$")
  if(!(format %in% c(".Rmd", ".Qmd", ".qmd"))){
    c("Accepted file suffixes are `.Rmd` and `.qmd`.",
      i = "Please rename {.file {file}} and try again.") |>
      cli::cli_abort()
  }
  
  # get `metadata_example.Rmd` and move it to the specified file name
  # NOTE: This works because Rmarkdown and Quarto documents
  # can be formatted identically. If they vary, we will need to ship
  # separate versions of `metadata_example`
  source_file <- system.file("extdata", 
                             "metadata_example.Rmd",
                             package = "delma")
  if(file.exists(file)){
    if(overwrite){
      if(!quiet){
        cli::cli_progress_step("Overwriting existing file {.file {file}}")        
      }
      file.copy(from = source_file,
                to = file,
                overwrite = TRUE) |>
        invisible()
      if(!quiet){
        cli::cli_progress_done()
        use_metadata_closure_message(file)        
      }
    }else{
      if(!quiet){
        c("File {.file {file}} already exists and has not been overwritten.",
          i = "Set `overwrite = TRUE` to change this behaviour.") |>
          cli::cli_inform()         
      }
    }
  }else{
    if(!quiet){
      cli::cli_progress_step("Writing {.file {file}} to top directory folder.")      
    }
    file.copy(from = source_file,
              to = file,
              overwrite = overwrite) |>
      invisible()
    if(!quiet){
      cli::cli_progress_done()
      use_metadata_closure_message(file)
    }
  }
  cli::cli_progress_done()
}

#' Internal function to say something useful about the dataset
#' @noRd
#' @keywords Internal
use_metadata_closure_message <- function(file){
  cli::cli_bullets(c(
    i = paste(
      c(" Edit {.file {file}} before converting to EML.")
    )
  ))
}