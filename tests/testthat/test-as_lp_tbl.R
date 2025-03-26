test_that("`as_lp_tbl()` works for class tbl_lp", {
  x <- read_md("testdata/bionet_metadata.Rmd") |>
    as_lp_tbl()
  inherits(x, 
           c("tbl_lp", "tbl_df", "tbl", "data.frame")) |>
    expect_true()
  expect_gte(nrow(x), 40)
})

# as_eml_tibble.list
test_that("`as_lp_tbl()` works for class list", {
  x <- xml2::read_xml("testdata/bionet_metadata.xml") |>
    as_eml_list()
  inherits(x, "list") |>
    expect_true()
  y <- as_lp_tbl(x)
  inherits(y, 
           c("tbl_lp", "tbl_df", "tbl", "data.frame")) |>
    expect_true()
  expect_gte(nrow(y), 40) 
})

test_that("as_lp_tbl() works for xml documents", {
  x <- xml2::read_xml("testdata/bionet_metadata.xml") |>
    as_lp_tbl()
  inherits(x, c("tbl_lp", "tbl_df", "tbl", "data.frame")) |>
    expect_true()
  expect_gte(nrow(x), 40)
})
