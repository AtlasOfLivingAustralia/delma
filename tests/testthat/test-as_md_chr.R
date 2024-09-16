# as_md_chr.tbl_df

# as_md_chr.list

# as_md_chr.xml_document
test_that("as_md_chr() converts xml correctly", {
  x <- read_md_xml("testdata/meta_example.xml")
  y <- as_md_chr(x) # works
  expect_null(names(y))
  expect_equal(class(y), "character")
  expect_true(grepl("^<h1 metadata", y[1]))
  expect_gte(length(y), 10)
})