# test for write_eml()
test_that("`write_eml()` fails with no arguments", {
  write_eml() |> 
    expect_error()
})

test_that("`write_eml()` fails with object but no file", {
  obj <- tibble::tibble(level = 1,
                        label = "eml",
                        text = "something",
                        attributes = NA)
  write_eml(obj) |> 
    expect_error()
})

test_that("`write_eml()` fails with file but no object", {
  write_eml(file = "something.xml") |> 
    expect_error()
})

test_that("write_eml() fails when incorrect file extension given", {
  obj <- tibble::tibble(level = 1,
                        label = "eml",
                        text = "something",
                        attributes = NA)
  file_out <- "test_file.pptx"
  write_eml(md_example, file_out) |>
    expect_error()
})


# tests for write_md()
test_that("`write_md()` fails with no arguments", {
  write_md() |> expect_error()
})

test_that("`write_md()` fails with object but no file", {
  obj <- tibble::tibble(level = 1,
                        label = "eml",
                        text = "something",
                        attributes = NA)
  write_md(obj) |> 
    expect_error()
})

test_that("`write_md()` fails with file but no object", {
  write_md(file = "something.xml") |> 
    expect_error()
})

test_that("write_md() fails when incorrect file extension given", {
  md_example <- tibble::tibble(level = 1,
                               label = "eml",
                               text = "something",
                               attributes = NA)
  file_out <- "test_file.xml"
  write_md(md_example, file_out) |>
    expect_error()
})
