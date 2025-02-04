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
#'                     package = "paperbark")
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
  # import and convert to tibble
  lightparser::split_to_tbl(file) |>
    run_rmd_code() |> 
    assign_yaml_info()
}

# is it sensible to rebuild rendering code for blocks in rmarkdown files? 
# Should we use quarto or rmarkdown to do this instead?
## BUT if we can assume that they will only use R for simple stuff, we might be ok

assign_yaml_info <- function(x){
  if(!any(x$type == "yaml")){
    x
  }else{
    row <- which(x$type == "yaml")[1]
    yaml_params <- x$params[[row]]
    
  }
}

#' @rdname read_md
#' @param x Object of any class handled by `paperbark`; i.e. `character`, 
#' `tbl_df`, `list` or `xml_document`.
#' @importFrom rlang abort
#' @importFrom xml2 write_xml
#' @export
write_md <- function(x, file){
  
  # stop if file suffix is incorrect
  check_is_single_character(file)
  # if(!grepl(".md$", file)){
  #   abort("`write_md()` only writes files with a `.md` suffix.")
  # }
  
  # check for correct format
  if(!inherits(x, "tbl_df")){
    x <- as_eml_tibble(x)
  }
  
  # x |>
  #   remove_eml_header() |>
  #   as_eml_chr() |>
  #   writeLines(con = file)
  x |>
    lightparser::combine_tbl_to_file(output_file = file)
}
