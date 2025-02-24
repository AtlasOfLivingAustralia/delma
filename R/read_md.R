#' Read or write markdown-formatted metadata
#' 
#' `read_md()` imports metadata from a markdown file into the workspace as a 
#' `tibble`. `write_md()` write a `string`, `tibble`, `list` or `xml_document` 
#' to a markdown file.
#' @param file Filename to read from or write to. Must be either `.md`, `.Rmd`
#' or `.Qmd` file.
#' @returns `read_md()` returns an object of class `tbl_df`, `tbl` and 
#' `data.frame` (i.e. a `tibble`). `write_md()` doesn't return anything, and
#' is called for the side-effect of writing the specified markdown file to disk.
#' @examples \dontrun{
#' # read from a url
#' file <- system.file("example_data", 
#'                     "README_md_example.md", 
#'                     package = "delma")
#' df <- read_md(file)
#' 
#' # write to disk
#' write_md(df, "example.md")
#' }
#' @importFrom rlang abort
#' @export
read_md <- function(file){
  # abort if file missing
  if(missing(file)){
    abort("`file` is missing, with no default.")
  }
  # check file is correctly specified
  check_is_single_character(file)
  # check valid suffix (update to Rmd, md, Qmd?)
  # if(!grepl("\\.md$", file)){
  #   abort("Argument `file` must end in the suffix `md`")
  # }
  # check file exists
  if(!file.exists(file)){
    abort("Specified `file` does not exist.")
  }
  
  # set a working directory
  temp_dir <- tempdir()
  
  # create a temporary file and convert output format to markdown
  temp_source <- glue("{temp_dir}/temp_source.Rmd")
  file.copy(from = file, 
            to = temp_source) |>
    invisible()
  convert_to_markdown_output(temp_source)
  
  # create a rendered version of this doc
  temp_md <- glue("{temp_dir}/temp_md.md")
  rmarkdown::render(input = temp_source,
                    output_file = temp_md) |>
    suppressWarnings() |>
    suppressMessages()
  add_standard_yaml(temp_md)
  # NOTE: we MUST call `render()` here, and not `knit()`.
  # Only the former will extract and calculate metadata that is necessary to place
  # title and date properly in the body of the markdown file
  
  # purrr::quietly doesn't work on `render()`
  
  # import both tibbles
  tbl_rendered <- lightparser::split_to_tbl(temp_md)
  tbl_source <- lightparser::split_to_tbl(file)
  
  # clean `tbl_rendered` into format expected by `delma`
  result <- tbl_rendered |>
    clean_header_level() |> # downfill heading level
    dplyr::filter(.data$type != "yaml",
                  is.na(.data$heading),
                  .data$heading_level > 0) |>
    clean_text() |>
    dplyr::select("heading_level", "section", "text") |>
    dplyr::rename("level" = "heading_level", 
                  "label" = "section") |>
    add_eml_header()
  
  # add code blocks with titles as eml attributes.
  # browser()
  # tbl_source |>
  #   dplyr::filter(.data$type == "block" &
  #                 !is.na(.data$label)) 
  # currently working here
  
  # clean up
  unlink(temp_dir, recursive = TRUE)
  return(result)
}

#' Internal function to clean text column
#' @param x A tibble
#' @noRd
#' @keywords Internal
clean_text <- function(x){
  x$text <- purrr::map(x$text,
             \(a){
               a <- trimws(a)
               if(length(a) < 2){
                 if(a == ""){
                   NA
                 }else{
                   a
                 }
               }else{
                 if(any(a == "")){
                   a[a == ""] <- "{BREAKPOINT}"
                   b <- glue_collapse(a, sep = " ") |>
                     strsplit(split = "\\{BREAKPOINT\\}") |>
                     purrr::pluck(!!!list(1)) |>
                     trimws() |>
                     str_replace("\\s{2,}", "\\s") 
                   as.list(b[b != ""])
                 }else{
                   glue_collapse(x, sep = " ") |>
                     as.character()
                 }                 
               }
             })
  x
}

#' Internal function to clean header levels
#' @param x a tibble with the column heading level
#' @noRd
#' @keywords Internal
clean_header_level <- function(x){
  heading_value <- 0
  for(i in c(2:nrow(x))){
    if(!is.na(x$heading_level[i])){
      heading_value <- x$heading_level[i]
    }else{
      x$heading_level[i] <- heading_value
    }
  }
  x
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
    capture.output()
  c(yaml_new,
    readLines(input)) |>
    writeLines(con = input)
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
    rlang::abort("yaml not found")
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
    capture.output()
  
  # add new yaml in place of old yaml
  result <- c(yaml_new,
              x[seq(yaml_end + 1, length(x), by = 1)])
  
  # write to file
  writeLines(result, con = input)
}