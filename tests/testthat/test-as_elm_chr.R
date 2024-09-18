# as_elm_chr.tbl_df

# as_elm_chr.list

# as_elm_chr.xml_document
test_that("as_elm_chr() converts xml correctly", {
  x <- read_elm("testdata/meta_example.xml")
  y <- as_elm_chr(x) # works
  expect_null(names(y))
  expect_equal(class(y), "character")
  expect_true(grepl("^<h1 metadata", y[1]))
  expect_gte(length(y), 10)
})
