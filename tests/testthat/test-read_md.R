test_that("`read_md()` fails with no arguments", {
  read_md() |>
    expect_error(regexp = "`file` is missing, with no default.")
})

test_that("`read_md()` fails with missing files", {
  read_md("something.md") |>
  expect_error(regexp = "Specified `file` does not exist.")
})

test_that("`read_md()` only accepts files that end in `.md`", {
  read_md("testdata/bionet_metadata.xml") |>
    expect_error(regexp = "only reads files with a")
})

test_that("read_md() works on a valid markdown file", {
  x <- read_md("testdata/bionet_metadata.md")
  expect_s3_class(x, "md")
  expect_gte(length(x), 100)
})