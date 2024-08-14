test_that("`read_md_chr()` fails with no arguments", {
  read_md_chr() |>
    expect_error(regexp = "`file` is missing, with no default.")
})

test_that("`read_md_chr()` fails with missing files", {
  read_md_chr("something.md") |>
  expect_error(regexp = "Specified `file` does not exist.")
})

test_that("`read_md_chr()` only accepts files that end in `.md`", {
  read_md_chr("testdata/bionet_metadata.xml") |>
    expect_error(regexp = "only reads files with a")
})

test_that("read_md_chr() works on a valid markdown file", {
  x <- read_md_chr("testdata/bionet_metadata.md")
  expect_true(inherits(x, c("md_tibble", "tbl_df")))
  expect_gte(nrow(x), 10)
})