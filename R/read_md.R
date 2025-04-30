#' Read markdown-formatted metadata
#' 
#' @description
#' `read_md()` imports metadata from a markdown file into the workspace as a 
#' `tibble`.
#' @param file Filename to read from. Must be either `.Rmd` or `.qmd` file.
#' @details
#' [read_md()] is unusual in that it calls [rmarkdown::render()] or 
#' [quarto::quarto_render()] internally to ensure code blocks and snippets 
#' are parsed correctly. This ensures dynamic content is rendered correctly in 
#' the resulting `EML` document, but makes this function considerably slower 
#' than a standard import function. Conceptually, therefore, it is closer to a 
#' renderer with output type `tibble` than a traditional `read_` function.
#' 
#' This approach has one unusual consequence; it prevents 'round-tripping' of 
#' embedded code. That is, dynamic content in code snippets within the 
#' metadata statement is rendered to plain text in `EML.` If that `EML` document 
#' is later re-imported to `Rmd` using [read_eml()] and [write_md()], formerly 
#' dynamic content will be shown as plain text. 
#' 
#' Internally, [read_md()] calls [lightparser::split_to_tbl()].
#' @returns `read_md()` returns an object of class `tbl_df`, `tbl` and 
#' `data.frame` (i.e. a `tibble`).
#' @examples \dontrun{
#' use_metadata_template("example.Rmd") 
#' df <- read_md("example.Rmd")
#' }
#' @export
read_md <- function(file){
  
  # check file is specified
  if(missing(file)){
    cli::cli_abort("`file` is missing, with no default.")
  }
  # check file exists
  if(!file.exists(file)){
    cli::cli_abort("Specified file \"{file}\" does not exist.")
  }
  # check file is correctly specified
  check_is_single_character(file)
  format <- check_valid_suffix(file) # check and return a valid format
  temp_dir <- safe_temp_directory() # set a working directory
  
  # create a temporary file and convert output format to markdown
  temp_source <- glue::glue("{temp_dir}/temp_source.Rmd")
  file.copy(from = file, 
            to = temp_source,
            overwrite = TRUE) |>
    invisible()

  # create a rendered version of this doc, as needed for the supplied `format`
  temp_md <- glue::glue("{temp_dir}/temp_md.md")
  
  switch(format, 
         "Quarto" = {
           # Copy .qmd file from local directory to temp directory; a
           # workaround required due to quarto's inability to render a document
           # anywhere except the directory where the .qmd file is located.
           
           # This solution copies qmd to temp directory and explicitly 
           # sets the temp directory to run `quarto_render()`
           invisible(
             file.copy(
               from = file,
               to = glue::glue("{temp_dir}/{file}"),
               overwrite = TRUE
             )
           )
           xfun::in_dir(glue::glue("{temp_dir}/"), 
                        # run Quarto in the directory of the input file
                        report <- quarto::quarto_render(
                          input = basename(glue::glue("{file}")),
                          output_format = "md",
                          output_file = "temp_md.md", # output file will be created in the temp directory
                          quiet = TRUE
                          )
           )
           
           },
         {rmarkdown::render(input = temp_source,
                            output_format = "md_document", # rmarkdown::md_document() ?
                            output_file = temp_md,
                            quiet = TRUE)}
  )
  # NOTE: we MUST call `render()` here, and not `knit()`.
  # Only `render()` uses `pandoc`, meaning it will extract and 
  # calculate metadata that is necessary to place the
  # title and date properly in the body of the markdown file
  
  # rendered markdown files have no yaml, but need one for importing via
  # lightparser. Add a placeholder YAML here (note: data not used)
  add_standard_yaml(temp_md)
  
  # Parse markdown info as a tibble
  result <- read_lp(temp_md) |>
    place_eml_first() |>
    parse_lp_to_tibble()
  
  # import 'unrendered' tibble, extract hidden lists as attributes
  eml_attributes <- read_lp(file) |>
    parse_eml_attributes(tags = result$label)
  
  # clean up
  unlink(temp_dir, recursive = TRUE)
  
  # join and return
  if(is.null(eml_attributes)){
    result
  }else{
    join_eml_attributes(result, eml_attributes)
  }
}

#' Internal function to ensure no headings are placed before eml
#' @noRd
#' @keywords Internal
place_eml_first <- function(df){
  # Remove any headings placed *before* EML
  # NOTE: This step is important for Quarto documents. lightparser reads  
  #       yaml title as a heading in qmd but not Rmd, which must be removed
  eml_checker <- df$heading |>
    tolower() |>
    grepl("^eml", x = _) # accounts for both `eml:eml` and `EML`
  if(any(eml_checker)){
    eml_row <- which(eml_checker)[1]
    if(eml_row > 1){ # if EML is first, impossible for a header to be earlier
      df <- df[seq(from = eml_row, to = nrow(df)), ]
    }
  }
  # Note that the approach above *always* removes yaml. If that is needed later
  # this approach will require revision
  df
}


#' Internal function to check file name contains a supported suffix
#' @noRd
#' @keywords Internal
check_valid_suffix <- function(file){
  suffix <- stringr::str_extract(file, "\\.[:alnum:]+$")
  if(!(suffix %in% c(".Rmd", ".Qmd", ".qmd"))){
    c("Invalid file suffix", 
      "Accepted formats are `.Rmd` or `.qmd`") |>
    cli::cli_abort(call = rlang::caller_env())
  }else{
    switch(suffix,
           # ".md" = "basic",
           ".Rmd" = "Rmarkdown",
           ".Qmd" = "Quarto",
           ".qmd" = "Quarto")
  }
}

#' Internal function to create a temporary working directory.
#' This is needed because wiping `tempdir()` breaks heaps of stuff in R,
#' apparently including stored data from loaded packages.
#' @noRd
#' @keywords Internal
safe_temp_directory <- function(){
  safe_location <- glue::glue("{tempdir()}/delma-temp-working-directory") |>
    as.character()
  if(!dir.exists(safe_location)){
    dir.create(safe_location)  
  }
  safe_location
}

#' Internal function to add yaml to a file that is missing one
#' @returns Called for side-effect of editing file given by `input`
#' @noRd
#' @keywords Internal
add_standard_yaml <- function(input){
  # write new yaml as a text string
  # NOTE: This isn't actually used anywhere; it's a patch to get past
  # lightparser's import requirements
  yaml_new <- c("---" ,
                "author: unknown",
                "date: today",
                "---" )
  # write to supplied file
  c(yaml_new,
    readLines(input)) |>
    writeLines(con = input)
}

#' Internal function to extract tagged code blocks, to parse as attributes
#' @param x A tibble to extract attributes from
#' @param tags A vector of EML tags (`labels` col in source df) that are available for joining
#' @noRd
#' @keywords Internal
parse_eml_attributes <- function(x, tags){
  eml_check <- x$label == "eml"
  eml_check[is.na(eml_check)] <- FALSE
  if(any(eml_check)){
    x$label[which(eml_check)[1]] <- "eml:eml"
  }
  attr_chunks <- x |>
      dplyr::filter(.data$type == "block" &
                    .data$label %in% tags)
  if(nrow(attr_chunks) < 1){
    NULL
  }else{
    result <- purrr::map(attr_chunks$code,
               \(a){
                 contains_list_check <- any(grepl("^\\s?list\\(", a))
                 if(contains_list_check){
                   outcome <- glue::glue_collapse(a, sep = "\n") |>
                     parse(text = _) |>
                     eval() |>
                     try()
                   if(!inherits(outcome, "list")){ # try-error?
                     c("One of your named code blocks did not parse",
                       i = "These code blocks are used by `delma` to assign EML attributes",
                       i = "Consider revising code block '{attr(a, 'chunk_opts')$label}' to return a `list()`") |>
                     cli::cli_abort(call = rlang::caller_env())
                   }else{
                     outcome
                   }
                 }else{
                   c("One of your named code blocks does not contain `list()`",
                     i = "These code blocks are used by `delma` to assign EML attributes",
                     i = "Consider labelling code block '{attr(a, 'chunk_opts')$label}' to something else, or adding a `list()`") |>
                   cli::cli_abort(call = rlang::caller_env())
                 }
               })
    names(result) <- attr_chunks$label
    result
  }
}

#' Internal function to extract tagged code blocks, to parse as attributes
#' @param df A tibble
#' @param attr_list Named list of attributes to be appended to df
#' @noRd
#' @keywords Internal
join_eml_attributes <- function(df, attr_list){
  for(i in seq_along(attr_list)){
    row <- which(df$label == names(attr_list)[i])
    df$attributes[[row]] <- attr_list[[i]]
  }
  df
}