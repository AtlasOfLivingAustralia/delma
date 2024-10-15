# test for write_eml()
test_that("`write_eml()` fails with no arguments", {
  write_eml() |> 
    expect_error()
})

test_that("`write_eml()` fails with object but no file", {
  obj <- c("# header 1", "## header 2")
  write_eml(obj) |> 
    expect_error()
})

test_that("`write_eml()` fails with file but no object", {
  write_eml(file = "something.xml") |> 
    expect_error()
})

test_that("write_eml() fails when incorrect file extension given", {
  md_example <- c("# header 1", "## header 2")
  file_out <- "test_file.md"
  write_eml(md_example, file_out) |>
    expect_error()
})

test_that("`write_eml()` works for characters", {
  md_example <- c("# header 1", "## header 2")
  file_out <- "test_file.xml"
  write_eml(md_example, file_out)
  # check file has been written to xml
  file_out |>
    file.exists() |>
    expect_true()
  # check result has correct format
  result <- xml2::read_xml(file_out) 
  expect_s3_class(result, "xml_document")
  # clean up
  unlink(file_out)
})

test_that("`write_elm()` works for lists", {
  x <- list(eml = list(archive = list("something")))
  file_out <- "test_file.xml"
  write_eml(x, file_out)
  # check file has been written to xml
  file_out |>
    file.exists() |>
    expect_true()
  # check result has correct format
  result <- xml2::read_xml(file_out) 
  expect_s3_class(result, "xml_document")
  # clean up
  unlink(file_out)
})


# tests for write_md()
test_that("`write_md()` fails with no arguments", {
  write_md() |> expect_error()
})

test_that("`write_md()` fails with object but no file", {
  obj <- c("# header 1", "## header 2")
  write_md(obj) |> 
    expect_error()
})

test_that("`write_md()` fails with file but no object", {
  write_md(file = "something.xml") |> 
    expect_error()
})

test_that("write_md() fails when incorrect file extension given", {
  md_example <- c("# header 1", "## header 2")
  file_out <- "test_file.xml"
  write_md(md_example, file_out) |>
    expect_error()
})

test_that("`write_md()` works for characters", {
  md_example <- c("# header 1", "## header 2")
  file_out <- "test_file.md"
  write_md(md_example, file_out)
  # check file has been written to md
  file_out |>
    file.exists() |>
    expect_true()
  # check result has correct format
  result <- readLines(file_out) 
  expect_equal(result, md_example)
  # clean up
  unlink(file_out)
})
