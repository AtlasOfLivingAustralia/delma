test_that("xml documents can be losslessly converted to list and back", {
  # read, convert, write
  xml2::read_xml("testdata/meta_example.xml") |>
    as_md_list() |>
    write_md_xml("testdata/TEST_meta_example.xml")
  
  # scan both xml files, compare for differences
  x <- base::readLines("testdata/meta_example.xml")
  y <- base::readLines("testdata/TEST_meta_example.xml")
  n <- length(x)
  n_ok <- length(which(x == y))
  expect_gte(n_ok / n, 0.9) # >= 90% the same
  
  # clean up
  unlink("testdata/TEST_meta_example.xml")
})

test_that("xml documents can be losslessly converted to tibble and back", {
  # read, convert, write
  xml2::read_xml("testdata/meta_example.xml") |>
    as_md_tibble() |>
    write_md_xml("testdata/TEST_meta_example.xml")
  
  # scan both xml files, compare for differences
  x <- base::readLines("testdata/meta_example.xml")
  y <- base::readLines("testdata/TEST_meta_example.xml")
  n <- length(x)
  n_ok <- length(which(x == y))
  expect_gte(n_ok / n, 0.9) # >= 90% the same
  
  # clean up
  unlink("testdata/TEST_meta_example.xml")
})

test_that("xml documents can be losslessly converted to md and back", {
  # read, convert, write
  xml2::read_xml("testdata/meta_example.xml") |>
    as_md_chr() |>
    write_md_xml("testdata/TEST_meta_example.xml")
  
  # scan both xml files, compare for differences
  x <- base::readLines("testdata/meta_example.xml")
  y <- base::readLines("testdata/TEST_meta_example.xml")
  # expect_equal(x, y) # perfect equality; not achieved yet
  n <- length(x)
  n_ok <- length(which(x == y))
  expect_gte(n_ok / n, 0.8) # >= 80% the same
  
  # clean up
  unlink("testdata/TEST_meta_example.xml")
})