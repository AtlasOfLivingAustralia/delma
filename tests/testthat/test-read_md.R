test_that("read_md() works", {
  x <- read_md("testdata/bionet_metadata.md")
  expect_s3_class(x, "md")
  expect_gte(length(x), 100)
})

# add test for write_md()