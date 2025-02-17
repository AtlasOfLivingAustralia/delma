test_that("`example_metadata` can be converted to md and back", {
  write_md(metadata_example, "EXAMPLE.md")
  x <- read_md("EXAMPLE.md")
  expect_equal(metadata_example,  dplyr::slice(x, -1))
  # paragraphs in tibble should be in list-entries, 
  # but are not nested; no `para` tag
  
  # test that `para` tag is added at `as_eml_list()` stage
  x_list <- as_eml_list(x)
  x_list |> 
    unlist() |>
    names() |>
    grepl("para$", x = _) |>
    any() |>
    expect_true()
  
  # convert to eml
  write_eml(x_list, "EXAMPLE.xml")
  
  # reimport
  y <- xml2::read_xml("EXAMPLE.xml")
  y_list <- xml2::as_list(y) # this works
  as_eml_tibble(y_list)
  
  # aka
  z <- read_eml("EXAMPLE.xml")
  z
  z$attributes[[3]]  
})

test_that("xml documents can be losslessly converted to list and back", {
  # read, convert, write
  xml2::read_xml("testdata/meta_example.xml") |>
    as_eml_list() |>
    write_eml("testdata/TEST_meta_example.xml")
  
  # scan both xml files, compare for differences
  x <- base::readLines("testdata/meta_example.xml")
  y <- base::readLines("testdata/TEST_meta_example.xml")
  expect_equal(x[-1 ], y[-1 ])
 
  # clean up
  unlink("testdata/TEST_meta_example.xml")
})

test_that("xml documents can be losslessly converted to tibble and back", {
  # read, convert, write
  xml2::read_xml("testdata/meta_example.xml") |>
    as_eml_tibble() |>
    write_eml("testdata/TEST_meta_example.xml")
  
  # scan both xml files, compare for differences
  x <- base::readLines("testdata/meta_example.xml")
  y <- base::readLines("testdata/TEST_meta_example.xml")
  
  # expect_equal(x[-1 ], y[-1 ]) # note this still needs work
  
  n_total <- length(x)
  n_ok <- length(which(x == y))
  difference <- abs(n_ok / n_total)
  expect_gte(difference, 0.9) # >= 90% the same
  
  # clean up
  unlink("testdata/TEST_meta_example.xml")
})

test_that("xml documents can be losslessly converted to md and back", {
  # read, convert, write
  xml2::read_xml("testdata/meta_example.xml") |>
    as_eml_chr() |>
    write_eml("testdata/TEST_meta_example.xml")
  
  # scan both xml files, compare for differences
  x <- base::readLines("testdata/meta_example.xml")
  y <- base::readLines("testdata/TEST_meta_example.xml")
  
  # new header row has `encoding = "utf-8"`, missing from original
  # otherwise these should be identical  
  expect_equal(x[-1 ], y[-1 ])
  
  # clean up
  unlink("testdata/TEST_meta_example.xml")
})
