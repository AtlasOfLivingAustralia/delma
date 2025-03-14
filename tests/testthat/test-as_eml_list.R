test_that("`as_eml_list()` works for class `tbl_df` imported from md", {
  x <- read_md("testdata/bionet_metadata.Rmd")
  result <- as_eml_list(x)
  expect_true(inherits(result, "list"))
  expect_equal(
    purrr::pluck_depth(result),
    max(x$level))
  expect_lte(
    length(unlist(result)),
    nrow(x))
})

test_that("`as_eml_list()` works for class `tbl_df` imported from xml", {
  x <- read_eml("testdata/meta_example.xml")
  result <- as_eml_list(x)
  expect_true(inherits(result, "list"))
  expect_equal(
    purrr::pluck_depth(result),
    max(x$level) + 1)
  expect_lte(
    length(unlist(result)),
    nrow(x))
})

test_that("`as_eml_list()` works for class `xml_document", {
  x <- xml2::read_xml("testdata/bionet_metadata.xml") |>
    as_eml_list()
  expect_true(inherits(x, "list"))
})
