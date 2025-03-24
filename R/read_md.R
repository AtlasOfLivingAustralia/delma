#' Read markdown-formatted metadata
#' 
#' `read_md()` imports metadata from a markdown file into the workspace as a 
#' `tibble`.
#' @param file Filename to read from. Must be either `.md`, `.Rmd`
#' or `.Qmd` file.
#' @details
#' [read_md()] is unusual in that it calls [rmarkdown::render()] or 
#' [quarto::quarto_render()] internally to ensure code blocks and snippets 
#' are parsed correctly. This ensures dynamic content is rendered correctly in 
#' the resulting `EML` document, but makes this function considerably slower 
#' than a standard import function. Conceptually, therefore, it is closer to a 
#' renderer with output type `tibble` than a traditional `read_` function.
#' 
#' This approach has one unusual consequence; it prevents 'round-tripping' of 
#' embedded code. That is, dynamic content written in code snippets within the 
#' metadata statement is rendered to plain text in `EML.` If that `EML` document 
#' is later re-imported to `Rmd` using [read_eml()] and [write_md()], formerly 
#' dynamic content will be shown as plain text. 
#' 
#' Internally, [read_md()] calls [lightparser::split_to_tbl()].
#' @returns `read_md()` returns an object of class `tbl_df`, `tbl` and 
#' `data.frame` (i.e. a `tibble`).
#' @examples \dontrun{
#' use_metadata("example.Rmd") 
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
    cli::cli_abort("Specified `file` does not exist.")
  }
  # check file is correctly specified
  check_is_single_character(file)
  format <- check_valid_suffix(file) # check and return a valid format
  temp_dir <- safe_temp_directory() # set a working directory
  
  # create a temporary file and convert output format to markdown
  temp_source <- glue::glue("{temp_dir}/temp_source.Rmd")
  file.copy(from = file, 
            to = temp_source) |>
    invisible()
  convert_to_markdown_output(temp_source)
  
  # create a rendered version of this doc, as needed for the supplied `format`
  temp_md <- glue::glue("{temp_dir}/temp_md.md")
  switch(format, 
         "Quarto" = {quarto::quarto_render(input = temp_source,
                                           output_file = temp_md,
                                           quiet = TRUE)},
         {rmarkdown::render(input = temp_source,
                            output_file = temp_md,
                            quiet = TRUE)}
  )
  # NOTE: we MUST call `render()` here, and not `knit()`.
  # Only `render()` uses `pandoc`, meaning it will extract and 
  # calculate metadata that is necessary to place the
  # title and date properly in the body of the markdown file
  
  # It may also be safer to use the `output_format` argument, rather 
  # than rewriting YAML (??).
  
  add_standard_yaml(temp_md)
  
  # import and clean the 'rendered' tibble
  result <- read_lp(temp_md) |>
    as_eml_tbl()

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

#' Internal function to check file name contains a supported suffix
#' @noRd
#' @keywords Internal
check_valid_suffix <- function(file){
  suffix <- stringr::str_extract(file, "\\.[:alnum:]+$")
  if(!(suffix %in% c(".md", ".Rmd", ".Qmd"))){
    c("Invalid file suffix", 
      "Please rename `{file}` to end in `.md`, `.Rmd` or `.Qmd`") |>
    cli::cli_abort(call = rlang::caller_env())
  }else{
    switch(suffix,
           ".md" = "basic",
           ".Rmd" = "Rmarkdown",
           ".Qmd" = "Quarto")
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


#' Internal function to convert an Rmd or Qmd to have `md_document` as output
#' @param input location of a file to be editted
#' @returns Called for side-effect of editing file given by `input`
#' @noRd
#' @keywords Internal
convert_to_markdown_output <- function(input){
  
  x <- readLines(input)
  
  # find yaml in plain text
  yaml_finder <- grepl("^---", x)
  if(length(which(yaml_finder)) < 2){
    cli::cli_abort("yaml not found",
                 call = rlang::caller_env())
  }
  yaml_end <- which(yaml_finder)[2]
  
  # import yaml text as a list 
  # convert output to markdown
  x_yaml <- rmarkdown::yaml_front_matter(input) |>
    ymlthis::yml_output(rmarkdown::md_document())
  
  # write this as a text string
  yaml_new <- ymlthis::yml(x_yaml, 
                           get_yml = FALSE,
                           author = FALSE,
                           date = FALSE) |>
    utils::capture.output()
  
  # add new yaml in place of old yaml
  result <- c(yaml_new,
              x[seq(yaml_end + 1, length(x), by = 1)])
  
  # write to file
  writeLines(result, con = input)
}

#' Internal function to add yaml to a file that is missing one
#' @returns Called for side-effect of editing file given by `input`
#' @noRd
#' @keywords Internal
add_standard_yaml <- function(input){
  # write this as a text string
  yaml_new <- list(author = "unknown",
                   date = "today") |>
    ymlthis::yml(get_yml = FALSE,
                 author = FALSE,
                 date = FALSE) |>
    utils::capture.output()
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