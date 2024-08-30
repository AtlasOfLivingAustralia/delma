# as_md_xml.chr

# as_md_xml.tbl_df

test_that("`as_md_xml()` works for class `character`", {
  x <- readLines("testdata/bionet_metadata.md") |>
    as_md_xml(x)
  expect_true(inherits(x, "xml_document"))
  # unclear how to test if this is valid xml
})