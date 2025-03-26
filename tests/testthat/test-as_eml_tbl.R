test_that("`as_eml_tbl()` works for class tbl_lp", {
  x <- read_lp("testdata/bionet_metadata.Rmd") |>
    as_eml_tbl()
  expect_true(inherits(x, c("tbl_df", "tbl", "data.frame")))
  expect_gte(nrow(x), 40)
})

# as_eml_tibble.list
test_that("`as_eml_tbl()` works for class list", {
  x <- xml2::read_xml("testdata/bionet_metadata.xml") |>
    as_eml_list()
  inherits(x, "list") |>
    expect_true()
  y <- as_eml_tbl(x)
  expect_true(inherits(y, c("tbl_df", "tbl", "data.frame")))
  expect_gte(nrow(y), 40) 
})

test_that("as_eml_tbl() works for xml documents", {
  x <- xml2::read_xml("testdata/bionet_metadata.xml") |>
    as_eml_tbl()
  expect_true(inherits(x, c("tbl_df", "tbl", "data.frame")))
  expect_gte(nrow(x), 40)
})
