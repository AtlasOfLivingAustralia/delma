# as_xml.md

# as_xml.tibble

test_that("`as_xml()` works for class `eml", {
  x <- read_md("testdata/bionet_metadata.md") |>
    as_eml()
  result <- as_xml(x)
  write_xml(result, "test.xml")
})