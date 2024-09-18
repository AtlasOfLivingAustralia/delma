test_that("`read_elm` fails with no arguments", {
  read_elm() |> expect_error()
})

test_that("`read_elm` works when `type` not specified", {
  x <- read_elm("testdata/bionet_metadata.md")
  expect_s3_class(x, c("tbl_df", "tbl", "data.frame"))
  expect_gte(nrow(x), 10)
})

test_that("`read_elm` fails for invalid `type`", {
  read_elm("testdata/bionet_metadata.md", 
           type = "something") |>
    expect_error()
})

test_that("`read_elm` fails for valid but incorrect type", {
  read_elm("testdata/bionet_metadata.md", 
           type = "xml") |>
    expect_error()
  read_elm("testdata/bionet_metadata.xml", 
           type = "chr") |>
    expect_error()
})

test_that("`read_elm_chr()` fails with no arguments", {
  read_elm_chr() |>
    expect_error(regexp = "`file` is missing, with no default.")
})

test_that("`read_elm_chr()` fails with missing files", {
  read_elm_chr("something.md") |>
  expect_error(regexp = "Specified `file` does not exist.")
})

test_that("`read_elm_chr()` only accepts files that end in `.md`", {
  read_elm_chr("testdata/bionet_metadata.xml") |>
    expect_error()
})

test_that("read_elm_chr() works on a valid markdown file", {
  x <- read_elm_chr("testdata/bionet_metadata.md")
  expect_s3_class(x, c("tbl_df", "tbl", "data.frame"))
  expect_gte(nrow(x), 10)
})

test_that("`read_elm_xml()` fails with no arguments", {
  read_elm_xml() |>
    expect_error(regexp = "`file` is missing, with no default.")
})

test_that("`read_elm_xml()` fails with missing files", {
  read_elm_chr("something.md") |>
    expect_error()
})

test_that("`read_elm_xml()` only accepts files that end in `.xml`", {
  read_elm_xml("testdata/bionet_metadata.md") |>
    expect_error()
})

test_that("read_elm_xml() works on a local xml file", {
  x <- read_elm_xml("testdata/bionet_metadata.xml")
  expect_s3_class(x, c("tbl_df", "tbl", "data.frame"))
  expect_gte(nrow(x), 10)
})

test_that("read_elm_xml() works on a url", {
  skip_if_offline()
  x <- read_elm_xml("https://collections.ala.org.au/ws/eml/dr368")
  expect_s3_class(x, c("tbl_df", "tbl", "data.frame"))
  expect_gte(nrow(x), 10)
})