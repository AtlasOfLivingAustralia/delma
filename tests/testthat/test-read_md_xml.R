test_that("`read_md_xml()` fails with no arguments", {
  read_md_xml() |>
    expect_error(regexp = "`file` is missing, with no default.")
})

test_that("`read_md_xml()` fails with missing files", {
  read_md_chr("something.xml") |>
    expect_error(regexp = "Specified `file` does not exist.")
})

test_that("`read_md_xml()` only accepts files that end in `.xml`", {
  read_md_xml("testdata/bionet_metadata.md") |>
    expect_error(regexp = "only reads files with a")
})

test_that("read_md_xml() works on a valid xml file", {
  x <- read_md_xml("testdata/bionet_metadata.xml")
  expect_s3_class(x, c("tbl_df", "tbl", "data.frame"))
  expect_gte(nrow(x), 10)
})