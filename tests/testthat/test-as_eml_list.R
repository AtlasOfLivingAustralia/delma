test_that("`as_eml_list()` works for class `tbl_lp` imported from md", {
  file <- system.file("extdata", 
                   "bionet_metadata.Rmd",
                   package = "delma") |>
    read_lp()
  expect_warning(as_eml_list(file), "Duplicate heading")
  x <- as_eml_list(file) |> suppressWarnings()
  inherits(x, "list") |>
    expect_true()
})

test_that("`as_eml_list()` works for class `tbl_df` imported from md", {
  x <- system.file("extdata", 
                   "bionet_metadata.Rmd",
                   package = "delma") |>
    read_md()
  result <- as_eml_list(x) |> suppressWarnings()
  expect_warning(as_eml_list(x))
  inherits(result, "list") |>
    expect_true()
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
  inherits(result, "list") |>
    expect_true()
  expect_gte(
    purrr::pluck_depth(result),
    max(x$level) + 1)
  expect_lte(
    length(unlist(result)),
    nrow(x))
})

test_that("`as_eml_list()` works for class `list`", {
  file <- system.file("extdata", 
                   "bionet_metadata.Rmd",
                   package = "delma") |>
    read_md()
  x <- as_eml_list(file) |> suppressWarnings()
  expect_warning(as_eml_list(file))
  y <- as_eml_list(x)
  inherits(y, "list") |>
    expect_true()
  expect_equal(x, y)
})

test_that("`as_eml_list()` works for class `xml_document", {
  x <- system.file("extdata", 
                   "bionet_metadata.xml",
                   package = "delma") |>
    xml2::read_xml() |>
    as_eml_list()
  inherits(x, "list") |>
    expect_true()
})

test_that("`as_eml_list()` adds <para> tags for long text passages", {
  x <- system.file("extdata", 
                   "bionet_metadata.Rmd",
                   package = "delma") |>
    read_md()
  
  x_list <- x |> 
    as_eml_list() |>
    suppressWarnings() # quiet expected warning from duplicate citetitle

  # 3 labels hold text with n_char > 60 (which triggers para tags)
  # organizationName, citation, abstract
  # it's a bit fiddly to get this exact answer, but you can see it using:
  # x |> 
  # tidyr::unnest(cols = "text") |>
  # dplyr::mutate(chr_count = nchar(text)) |>
  # dplyr::filter(chr_count > 60)
  
  # find headings in list and make sure each is followed by a para tag
  abstract <- x_list |>
    purrr::pluck(1, 1, "abstract")
  org_name <- x_list |>
    purrr::pluck(1, 1, "creator", "organizationName")
  citation <- x_list |>
    purrr::pluck(1, 2, 1, 1, "citation")
  
  expect_equal(names(abstract), "para")
})
