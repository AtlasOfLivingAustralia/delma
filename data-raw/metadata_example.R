# This script builds an example metadata statement as a tribble,
# and stores it in /data, following standard outlined in:
# https://r-pkgs.org/data.html

library(tibble)
library(usethis)
devtools::load_all() # as internal functions required

metadata_example <- tribble(
  ~level, ~label,     ~text,
  1,      "Dataset",  NA,
  2,      "Title",    "A Sentence Giving Your Dataset Title In Title Case"
) |>
  add_eml_header()

usethis::use_data(metadata_example, 
                  internal = FALSE,
                  overwrite = TRUE)