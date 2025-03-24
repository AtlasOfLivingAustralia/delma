test_that("`as_eml_tibble()` works for ", {
  x <- read_lp("testdata/bionet_metadata.Rmd") |>
    as_eml_tbl()
  expect_true(inherits(x, c("tbl_df", "tbl", "data.frame")))
  expect_gte(nrow(x), 40)
})

# as_eml_tibble.list

test_that("as_eml_tibble() works for xml documents", {
  x <- xml2::read_xml("testdata/bionet_metadata.xml") |>
    as_eml_tbl()
  expect_true(inherits(x, c("tbl_df", "tbl", "data.frame")))
  expect_gte(nrow(x), 40)
})
