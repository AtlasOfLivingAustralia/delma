test_that("`write_elm` fails with no arguments", {
  write_elm() |> expect_error()
})

test_that("`write_elm` fails with object but no file type", {
  obj <- c("# header 1", "## header 2")
  write_elm(obj) |> expect_error()
})

test_that("`write_elm` exports to markdown when `format` is missing", {
  md_example <- c("# header 1", "## header 2")
  file_out <- "test_file.md"
  write_elm(md_example, file_out)
  # check file has been written to markdown
  file_out |>
    file.exists() |>
    expect_true()
  # check markdown matches the provided data
  readLines(file_out) |>
    expect_equal(md_example)
  # clean up
  unlink(file_out)
})

test_that("`write_elm` exports to xml when `format` is missing", {
  x <- list(eml = list(archive = list("something")))
  file_out <- "test_file.xml"
  write_elm(x, file_out)
  # check file has been written to markdown
  file_out |>
    file.exists() |>
    expect_true()
  # check markdown matches the provided data
  xml2::read_xml(file_out) |>
    expect_s3_class("xml_document")
  # clean up
  unlink(file_out)
})

test_that("`write_elm` fails when `format` is invalid", {
  write_elm(c("# header 1", "## header 2"),
            "test_file.md",
            format = "nothing") |>
  expect_error()
})

test_that("`write_elm` fails when `format` and suffix are conflicting", {
  md_example <- c("# header 1", "## header 2")
  file_out <- "test_file.md"
  write_elm(md_example, file_out, format = "xml") |>
    expect_error()
})