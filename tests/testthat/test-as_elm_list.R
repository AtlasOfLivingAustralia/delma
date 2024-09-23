test_that("`as_elm_list()` works for class `tbl_df` imported from md", {
  x <- read_elm("testdata/bionet_metadata.md")
  result <- as_elm_list(x)
  expect_true(inherits(result, "list"))
  expect_equal(
    purrr::pluck_depth(result),
    max(x$level) + 1)
  expect_lte(
    length(unlist(result)),
    nrow(x))
})

test_that("`as_elm_list()` works for class `tbl_df` imported from xml", {
  x <- read_elm("testdata/meta_example.xml")
  result <- as_elm_list(x)
  expect_true(inherits(result, "list"))
  expect_equal(
    purrr::pluck_depth(result),
    max(x$level) + 1)
  expect_lte(
    length(unlist(result)),
    nrow(x))
})

# as_elm_list.xml_document
test_that("`as_elm_list()` works for class `xml_document", {
  x <- xml2::read_xml("testdata/bionet_metadata.xml") |>
    as_elm_list()
  expect_true(inherits(x, "list"))
})
