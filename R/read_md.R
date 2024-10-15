#' Read metadata from markdown
#' 
#' Import metadata from a markdown file.
#' @param file A file to import.
#' @returns An object of class `tbl_df`, `tbl` and `data.frame` (i.e. a `tibble`).
#' @importFrom rlang abort
#' @export
read_md <- function(file){
  # abort if file missing
  if(missing(file)){
    abort("`file` is missing, with no default.")
  }
  # check file is correctly specified
  check_is_single_character(file)
  # check valid suffix
  if(!grepl("\\.md$", file)){
    abort("Argument `file` must end in the suffix `md`")
  }
  # check file exists
  if(!file.exists(file)){
    abort("Specified `file` does not exist.")
  }
  # import and convert to tibble
  readLines(file) |> as_eml_tibble()
}