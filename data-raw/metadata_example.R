# This script builds an example metadata statement as a tribble,
# and stores it in /data, following standard outlined in:
# https://r-pkgs.org/data.html

# need to give info on:
  # how the data were collected
  # sensitive species and how they were treated (inc. generalisation)

library(tibble)
library(dplyr)
library(usethis)
devtools::load_all() # as internal functions required

metadata_example <- list(
  # resource information
  # https://eml.ecoinformatics.org/images/eml-resource.png
  tibble(
    level = 1L, 
    label = "Dataset",
    text = list(NA)),
  tibble(
    level = 2L,
    label = "Title",
    text = list(list("A Descriptive Title for your Dataset in Title Case",
                     "This title should be a single sentence. It will appear 
                      as the name of the resource throughout the ALA and GBIF 
                      and form part of the citation. Please use a descriptive 
                      title for users and avoid filenames and acronyms."))),
  tibble(
    level = 2L,
    label = "Abstract",
    text = list(list("A brief overview of the resource, broken into paragraphs",
                     "This should provide enough information to help potential 
                     users of the data to understand if it may be of interest. 
                      Example content may include.."))),
  tibble(
    level = 2L,
    label = "Creator",
    text = list(NA)),
  tibble(
    level = 3L,
    label = "Individual name",
    text = list(NA)),
  tibble(
    level = 4L,
    label = "Surname",
    text = list("Citizen")),
  tibble(
    level = 4L,
    label = "Given name",
    text = list("John")),
  tibble(
    level = 4L,
    label = "Electronic mail address",
    text = list("example@email.com")),
  tibble(
    level = 3L,
    label = "Organisation name",
    text = list("Put your organisation name here")),
  tibble(
    level = 3L,
    label = "Address",
    text = list(NA)),
  tibble(
    level = 4L,
    label = c("Delivery point",
              "City",
              "Administrative area",
              "Postal code",
              "Country"),
    text = list(
      "215 Road Street",
      "Canberra",
      "ACT",
      "2601",
      "Australia")),
  tibble(
    level = 2L,
    label = c("Pubdate", "Language", "Licenced"),
    text = list("2024-01-01", "EN", NA)),
  tibble(
    level = 3L,
    label = c("Licence name",
              "URL",
              "Identifier"),
    text = list(
      "Creative Commons Attribution 4.0 International",
      "https://creativecommons.org/licenses/by/4.0/",
      "CC-BY 4.0 (Int) 4.0"))
  # Dataset
  # https://eml.ecoinformatics.org/images/eml-dataset.png
) |>
  bind_rows() |>
  add_eml_header()

metadata_example$level <- as.integer(metadata_example$level)

usethis::use_data(metadata_example,
                  internal = FALSE,
                  overwrite = TRUE)