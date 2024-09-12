# as_eml.md

test_that("`as_md_list()` works for class `tbl_df`", {
  x <- read_md_xml("testdata/meta_example.xml") |>
    as_md_tibble()
  result <- as_md_list(x)
  expect_true(inherits(result, "list"))
  expect_equal(
    purrr::pluck_depth(result),
    max(x$level) + 1)
  expect_lte(
    length(unlist(result)),
    nrow(x))
  # conversion from tibble to eml doesn't retain attributes
})

# as_md_list.xml_document
test_that("`as_md_list()` works for class `xml_document", {
  x <- read_md_xml("testdata/bionet_metadata.xml") |>
    as_md_list()
  expect_true(inherits(x, "list"))
})