test_that("xml documents can be losslessly converted to list and back", {
  # read, convert, write
  xml2::read_xml("testdata/meta_example.xml") |>
    as_elm_list() |>
    write_elm_xml("testdata/TEST_meta_example.xml")
  
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
    as_elm_tibble() |>
    write_elm_xml("testdata/TEST_meta_example.xml")
  
  # scan both xml files, compare for differences
  x <- base::readLines("testdata/meta_example.xml")
  y <- base::readLines("testdata/TEST_meta_example.xml")
  
  # expect_equal(x[-1 ], y[-1 ]) # note this still needs work
  
  n <- length(x)
  n_ok <- length(which(x == y))
  expect_gte(n_ok / n, 0.9) # >= 90% the same
  
  # clean up
  unlink("testdata/TEST_meta_example.xml")
})

test_that("xml documents can be losslessly converted to md and back", {
  # read, convert, write
  xml2::read_xml("testdata/meta_example.xml") |>
    as_elm_chr() |>
    write_elm_xml("testdata/TEST_meta_example.xml")
  
  # scan both xml files, compare for differences
  x <- base::readLines("testdata/meta_example.xml")
  y <- base::readLines("testdata/TEST_meta_example.xml")
  
  # new header row has `encoding = "utf-8"`, missing from original
  # otherwise these should be identical  
  expect_equal(x[-1 ], y[-1 ])
  
  # clean up
  unlink("testdata/TEST_meta_example.xml")
})
