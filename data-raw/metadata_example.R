# This script builds an example metadata statement as a tribble,
# and stores it in /data, following standard outlined in:
# https://r-pkgs.org/data.html

library(tibble)
library(dplyr)
library(usethis)
devtools::load_all() # as internal functions required

metadata_example <- list(
  # resource information
  # https://eml.ecoinformatics.org/images/eml-resource.png
  tibble(
    level = 1, 
    label = "Dataset",
    text = NA),
  tibble(
    level = 2,
    label = c("Title",
              "Abstract",
              "Creator"),
    text = c("A Sentence Giving Your Dataset Title In Title Case",
             "A paragraph outlining the content of the dataset",
             NA)),
  tibble(
    level = 3,
    label = "Individual name",
    text = NA),
  tibble(
    level = 4,
    label = c("Surname", 
              "Given name", 
              "Electronic mail address"),
    text = c("Person",
             "Steve",
             "example@email.com")),
  tibble(
    level = 3,
    label = c("Organisation name",
              "Address"),
    text = c("Put your organisation name here",
             NA)),
  tibble(
    level = 4,
    label = c("Delivery point",
              "City",
              "Administrative area",
              "Postal code",
              "Country"),
    text = c("215 Road Street",
             "Canberra",
             "ACT",
             "2601",
             "Australia")),
  tibble(
    level = 2,
    label = c("Pubdate",
              "Language",
              "Licenced"),
    text = c("2024-01-01",
             "EN",
             NA)),
  tibble(
    level = 3,
    label = c("Licence name",
              "URL",
              "Identifier"),
    text = c("Creative Commons Attribution 4.0 International",
             "https://creativecommons.org/licenses/by/4.0/",
             "CC-BY 4.0 (Int) 4.0"))
  # Dataset
  # https://eml.ecoinformatics.org/images/eml-dataset.png
) |>
  bind_rows() |>
  add_eml_header()

usethis::use_data(metadata_example, 
                  internal = FALSE,
                  overwrite = TRUE)