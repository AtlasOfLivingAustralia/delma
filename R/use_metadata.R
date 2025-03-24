#' Write an example metadata statement to disk
#' 
#' This function places a metadata template at the address specified by `"file"`,
#' defaulting to `"metadata.Rmd"` in the working directory. The template is 
#' built in such a way that standard rendering with `rmarkdown` or Quarto to
#' HTML or PDF will function; but also that it renders to valid EML using
#' [render_metadata()]. 
#' @param file (string) A name for the resulting file, with either `.Rmd` or
#' `.Qmd` as a suffix. If `NULL` will default to `metadata.md`.
#' @param overwrite (logical) Should any existing file be overwritten? Defaults
#' to `FALSE`.
#' @param quiet (logical) Should messages be suppressed? Defaults to `FALSE`.
#' @returns Doesn't return anything to the workspace; called for the side-effect
#' of placing a metadata statement in the working directory.
#' @export
use_metadata <- function(file = NULL,
                         overwrite = FALSE,
                         quiet = FALSE){
  if(is.null(file)){
    file <- "metadata.md"
  }
  if(!quiet){
    cli::cli_progress_step("Creating template file `{file}`.")
    cli::cli_progress_done()    
  }
  
  # check format
  format <- stringr::str_extract(file, "\\.[:alnum:]+$")
  if(!(format %in% c(".Rmd", ".Qmd"))){
    c("Accepted file suffixes are `.Rmd` and `.Qmd`",
      i = "Please rename `{file}` and try again") |>
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
        cli::cli_progress_step("Overwriting existing file `{file}`.")        
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
      c("file `{file}` already exists and has not been overwritten",
        i = "set `overwrite = TRUE` to change this behaviour") |>
        cli::cli_inform()     
    }
  }else{
    if(!quiet){
      cli::cli_progress_step("Creating new file `{file}`.")      
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
}

#' Internal function to say something useful about the dataset
#' @noRd
#' @keywords Internal
use_metadata_closure_message <- function(file){
  cli::cli_bullets(c(
    v = "File template `{file}` saved to top folder in local directory.",
    i = paste(
      c(" Edit `{file}`") |> 
        cli::col_grey(), 
      c("then use {.fn build_metadata} to build final metadata statement.") |> 
        cli::col_grey()
    )
  ))
}