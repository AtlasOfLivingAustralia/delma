test_that("`as_tibble()` works for class `md`", {
  x <- read_md("testdata/bionet_metadata.md")
  result <- as_tibble(x)
  expect_true(inherits(result, c("tbl_df", "tbl", "data.frame")))
  expect_gte(nrow(result), 40)
})

# as_tibble.eml

# as_tibble.xml