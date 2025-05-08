# read_eml() tests
test_that("`read_eml()` fails with no arguments", {
  read_eml() |> expect_error()
})

test_that("`read_eml()` fails for invalid format", {
  read_eml("testdata/bionet_metadata.Rmd") |>
    expect_error()
})

test_that("`read_eml()` works for a url", {
  skip_if_offline()
  x <- read_eml("https://collections.ala.org.au/ws/eml/dr368")
  expect_s3_class(x, c("tbl_df", "tbl", "data.frame"))
  expect_gte(nrow(x), 10)
})

test_that("read_eml() works on a local xml file", {
  x <- system.file("extdata", 
                   "bionet_metadata.xml",
                   package = "delma") |>
    read_eml()
  expect_s3_class(x, c("tbl_df", "tbl", "data.frame"))
  expect_gte(nrow(x), 10)
})


# read_md() tests
test_that("`read_md()` fails with no arguments", {
  read_md() |>
    expect_error(regexp = "`file` is missing, with no default.")
})

test_that("`read_md()` fails with missing files", {
  read_md("something.Rmd") |>
    expect_error(regexp = "Specified file \"something.Rmd\" does not exist.")
})

test_that("`read_md()` only accepts files that end in `.Rmd` or `.qmd", {
  x <- system.file("extdata", 
                   "bionet_metadata.xml",
                   package = "delma") |>
    read_md() |>
    expect_error()
})

test_that("read_md() works on a valid markdown file", {
  x <- system.file("extdata", 
                   "bionet_metadata.Rmd",
                   package = "delma") |>
    read_md()
  expect_s3_class(x, c("tbl_df", "tbl", "data.frame"))
  expect_gte(nrow(x), 10)
})

test_that("read_md() works on boilerplate file", {
  file <- system.file("extdata",
                      "metadata_example.Rmd",
                      package = "delma")
  x <- read_md(file)
  expect_s3_class(x, c("tbl_df", "tbl", "data.frame"))
  expect_gte(nrow(x), 10)
})