# as_xml.md

# as_xml.tibble

test_that("`as_xml()` works for class `eml", {
  # starting from md
  x <- read_md("testdata/bionet_metadata.md") |>
    as_eml()
  result <- as_xml(x)
  # write_xml(result, "test.xml")
  
  # or from xml
  x <- read_md("testdata/bionet_metadata.md") |>
    as_eml()
  result <- as_xml(x)
  
  expect_true(inherits(result, "xml_document"))
  # unclear how to test if this is valid xml
})