#' Write an example metadata template to the working directory
#' 
#' Test function
#' @param file (string) a file name to place 
#' @export
use_metadata <- function(file = "metadata.Rmd"){
  source_file <- system.file("extdata", 
                             "metadata_example.md", 
                             package = "delma")
  file.copy(from = source_file,
            to = file)
}