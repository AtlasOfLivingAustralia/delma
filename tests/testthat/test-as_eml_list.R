test_that("`as_eml_list()` works for class `tbl_df` imported from md", {
  x <- read_md("testdata/bionet_metadata.Rmd")
  result <- as_eml_list(x)
  expect_true(inherits(result, "list"))
  # note: conversion to tibble reduces depth by one
  # it would appear that some xml have greater compression than this, hence 
  # use of `expect_gte()` not `expect_equal()`
  expect_gte(
    purrr::pluck_depth(result),
    max(x$level) + 1)
  expect_lte(
    length(unlist(result)),
    nrow(x))
})

test_that("`as_eml_list()` works for class `tbl_df` imported from xml", {
  x <- read_eml("testdata/meta_example.xml")
  result <- as_eml_list(x)
  expect_true(inherits(result, "list"))
  expect_gte(
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
