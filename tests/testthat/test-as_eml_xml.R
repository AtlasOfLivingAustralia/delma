# as_eml_xml.chr

# as_eml_xml.tbl_df

test_that("`as_eml_xml()` works for class `character`", {
  x <- readLines("testdata/bionet_metadata.md") |>
    as_eml_xml(x)
  expect_true(inherits(x, "xml_document"))
  # unclear how to test if this is valid xml
})
