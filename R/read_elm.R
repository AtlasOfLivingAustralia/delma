#' Read metadata from markdown or xml
#' 
#' Import metadata from a markdown file, or xml file locally or online. 
#' @name read_elm
#' @param file Filename or url (latter for xml only).
#' @param format What format are the data in? Should be either `"md"` (for 
#' markdown) or `"xml"`. If missing (the default), the function will guess 
#' based on the file suffix.
#' @returns An object of class `tbl_df`, `tbl` and `data.frame` (i.e. a `tibble`).
#' @importFrom glue glue
#' @importFrom rlang abort
#' @importFrom stringr str_extract
#' @export
read_elm <- function(file,
                     format){
  
  # check format, but only if supplied
  if(!missing(format)){
    check_is_single_character(format)
    switch(format, 
           "xml" = read_elm_xml(file),
           "md" = read_elm_md(file),
           {bullets <- c(glue("Specified `format` not recognized (\"{format}\")"),
                         i = "valid values are \"md\" or \"xml\"")
           abort(bullets)}
    )
  # otherwise auto-detect file type
  }else{
    if(grepl("(https?|ftp)://[^ /$.?#].[^\\s]*", file)){  # check for urls
      read_elm_xml(file)
    }else{
      file_suffix <- str_extract(file, "\\.[:alpha:]+$")
      switch(file_suffix, 
             ".md" = read_elm_md(file),
             ".xml" = read_elm_xml(file),
             {bullets <- c(glue("Specified `file` suffix not recognized (\"{file_suffix}\")"),
                           i = "valid file extensions are \".md\" or \".xml\"")
             abort(bullets)})
    }    
  }
}

#' Internal function to check for characters
#' @importFrom glue glue
#' @importFrom rlang abort
#' @noRd
#' @keywords Internal
check_is_single_character <- function(x){
  if(!inherits(x, "character")){
    abort("Supplied object is not of type 'character'")
  }
  if(length(x) != 1L){
    abort(glue("Object is of length {length(x)}, should be 1"))
  }
}

#' @rdname read_elm
#' @importFrom rlang abort
#' @export
read_elm_md <- function(file){
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
  readLines(file) |> as_elm_tibble()
}

#' @rdname read_elm
#' @importFrom rlang abort
#' @importFrom xml2 read_xml
#' @export
read_elm_xml <- function(file){
  # abort if file missing
  if(missing(file)){
    abort("`file` is missing, with no default.")
  }
  # check file is correctly specified
  check_is_single_character(file)
  # check is either a url or ends in .xml
  if(!grepl("(https?|ftp)://[^ /$.?#].[^\\s]*", file)){ # is not a url
    # check valid suffix
    if(!grepl("\\.xml$", file)){
      abort("Argument `file` must end in the suffix `xml`")
    }
    # check file exists
    if(!file.exists(file)){
      abort("Specified `file` does not exist.")
    }
  }

  # import & convert to tibble
  read_xml(file) |> as_elm_tibble()
}
