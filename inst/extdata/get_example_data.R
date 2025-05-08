# This script is to get data for running tests
# It is not intended to be run regularly, or as part of the test suite

# `meta_example.xml` is not created by this script.

library(xml2)
devtools::load_all()

# get the xml file
path <- "./tests/testthat/testdata"
xml_file <- glue::glue("{path}/bionet_metadata.xml")
rmd_file <- glue::glue("{path}/bionet_metadata.Rmd")

xml2::read_xml("https://collections.ala.org.au/ws/eml/dr368") |>
  xml2::write_xml(file = xml_file)

# convert to markdown
xml_file |>
  read_eml() |>
  write_md(file = rmd_file)
