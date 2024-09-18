test_that("`as_tibble()` works for class `character`", {
  x <- readLines("testdata/bionet_metadata.md") |>
    as_elm_tibble()
  expect_true(inherits(x, c("tbl_df", "tbl", "data.frame")))
  expect_gte(nrow(x), 40)
})

# as_elm_tibble.list

# as_elm_tibble.xml_document
test_that("as_elm_tibble() works for xml documents", {
  x <- xml2::read_xml("testdata/bionet_metadata.xml") |>
    as_elm_tibble()
  expect_true(inherits(x, c("tbl_df", "tbl", "data.frame")))
  expect_gte(nrow(x), 40)
})
