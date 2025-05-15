#' Write an example metadata statement to disk
#' 
#' @description
#' This function places a metadata template at the address specified by `"file"`,
#' defaulting to `"metadata.Rmd"` in the working directory. The template is 
#' built in such a way that standard rendering with `rmarkdown` or Quarto to
#' HTML or PDF will function; but also that it renders to valid EML when 
#' processed using [read_md()] and [write_eml()]. 
#' @param file (string) A name for the resulting file, with either `.Rmd` or
#' `.qmd` as a suffix. If `NULL` will default to `metadata.md`.
#' @param overwrite (logical) Should any existing file be overwritten? Defaults
#' to `FALSE`.
#' @param quiet (logical) Should messages be suppressed? Defaults to `FALSE`.
#' @returns Doesn't return anything to the workspace; called for the side-effect
#' of placing a metadata statement in the working directory.
#' @examples
#' \dontshow{
#' .old_wd <- setwd(tempdir())
#' }
#' use_metadata_template("example.Rmd") 
#' \dontshow{
#' setwd(.old_wd)
#' }
#' @export
use_metadata_template <- function(file = NULL,
                         overwrite = FALSE,
                         quiet = FALSE){
  if(is.null(file)){
    file <- "metadata.Rmd"
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
  
  # We set some quite convoluted logic below re: writing behaviour.
  # NOTE: This depends on `overwrite` and `quiet` (both FALSE by default),
  # but ALSO asks the first time this function is called (i.e. when file.exists
  # returns FALSE. 
  # This is for compliance with CRAN policy:
  # "Packages should not write in the user’s home filespace...Limited exceptions 
  # may be allowed in interactive sessions if the package obtains confirmation 
  # from the user."
  # (https://cran.r-project.org/web/packages/policies.html checked 2025-05-12)
  if(file.exists(file)){
    if(overwrite){ # i.e. user has changed the default
      if(!quiet){
        cli::cli_progress_step("Overwriting existing file {.file {file}}") 
      }
      file.copy(from = source_file,
                to = file,
                overwrite = TRUE) |>
        invisible()
      cli::cli_progress_done()
      use_metadata_closure_message(file)
    }else{ # i.e. overwrite = FALSE
      if(!quiet){
        cli::cli_inform(c("File {.file {file}} already exists and has not been overwritten.",
                        i = "Set `overwrite = TRUE` to change this behaviour."))
      }
    }
  }else{ # if file.exists = FALSE
    if(!quiet){
      header <- glue::glue("You have requested to write a metadata statement to `{file}`")
      if(rlang::is_interactive()){ 
        
        choice <- cli_menu(
          header = "You have requested to write a metadata statement to `{.file {file}}`",
          prompt = "Do you want to proceed?",
          file = file,
          choices = c("Yes", "No"))
        if(choice == 1){
          cli::cli_progress_step("Writing {.file {file}} to top directory folder.")  
          file.copy(from = source_file,
                    to = file,
                    overwrite = overwrite) |>
            invisible()
          cli::cli_progress_done()
          use_metadata_closure_message(file)
        }else{
          cli::cli_inform(c(i = "Exiting..."))
          # exits process quietly
          invokeRestart("abort")
        }
      }else{ # not quiet, not interactive
        cli::cli_progress_step("Writing {.file {file}} to top directory folder.")  
        file.copy(from = source_file,
                  to = file,
                  overwrite = overwrite) |>
          invisible()
        cli::cli_progress_done()
        use_metadata_closure_message(file)
      }
    }else{ # quiet
      file.copy(from = source_file,
                to = file,
                overwrite = overwrite) |>
        invisible()
    }
  }
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