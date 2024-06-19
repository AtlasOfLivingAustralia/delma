# as_eml.md

test_that("`as_eml()` works for class `tbl_df`", {
  x <- read_md("testdata/bionet_metadata.md") |>
    as_tibble()
  result <- as_eml(x)
  expect_true(inherits(result, c("eml", "list")))
  expect_equal(
    purrr::pluck_depth(result),
    max(x$level) + 1)
  expect_lte(
    length(unlist(result)),
    nrow(x))
})

# as_eml.xml_document