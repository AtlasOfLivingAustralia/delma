# as_elm_xml.chr

# as_elm_xml.tbl_df

test_that("`as_elm_xml()` works for class `character`", {
  x <- readLines("testdata/bionet_metadata.md") |>
    as_elm_xml(x)
  expect_true(inherits(x, "xml_document"))
  # unclear how to test if this is valid xml
})
