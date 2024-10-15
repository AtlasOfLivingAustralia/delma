# as_eml_chr.tbl_df

# as_eml_chr.list

# as_eml_chr.xml_document
test_that("as_eml_chr() converts xml correctly", {
  x <- read_eml("testdata/meta_example.xml")
  y <- as_eml_chr(x) # works
  expect_null(names(y))
  expect_equal(class(y), "character")
  expect_true(grepl("^<h1 metadata", y[1]))
  expect_gte(length(y), 10)
})
