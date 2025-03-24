test_that("`use_metadata()` can be imported, written to EML, and back", {
  
  # set up a file for testing
  use_metadata("EXAMPLE.Rmd", 
               overwrite = TRUE,
               quiet = TRUE)
  
  # first read using `lightparser` format
  x <- read_lp("EXAMPLE.Rmd")
  inherits(x, c("tbl_lp", "tbl_df", "tbl", "data.frame")) |>
    expect_true()
  expect_equal(
    colnames(x),
    c("type", "label", "params", "text", "code", "heading", "heading_level", "section"))
  expect_gte(nrow(x), 50)
  
  # that's useful; but actually read_lp() isn't exported, because
  # it can't parse properly to tibble without the `render()` stage
  # that is built into `read_md()`. Swap to `read_md()` for later testing.
  
  # to tibble
  x_df <- read_md("EXAMPLE.Rmd")
  inherits(x_df, 
           c("tbl_lp", "tbl_df", "tbl", "data.frame")) |>
    expect_true()
  expect_equal(
    colnames(x_df),
    c("level", "label", "text", "attributes"))
  expect_lte(nrow(x_df), nrow(x))
  expect_equal(
    which(x_df$label == "eml:eml"), c(1))
  
  # to list
  x_list <- as_eml_list(x_df)
  inherits(x_list, "list") |>
    expect_true()
  expect_equal(length(x_list), 1L)
  expect_equal(names(x_list), "eml:eml")
  # test that `para` tag is added at `as_eml_list()` stage
  x_list |> 
    unlist() |>
    names() |>
    grepl("para$", x = _) |>
    any() |>
    expect_true()
  
  # convert to eml
  write_eml(x_list, "EXAMPLE.xml")
  file.exists("EXAMPLE.xml") |>
    expect_true()
  
  # reimport
  y <- xml2::read_xml("EXAMPLE.xml")
  inherits(y, c("xml_document", "xml_node")) |>
    expect_true()
  
  # to list
  y_list <- as_eml_list(y)
  inherits(y_list, "list") |>
    expect_true()
  expect_equal(length(y_list), 1L)
  expect_equal(names(y_list), "eml") # NOTE `xml2` simplifies `eml:eml` tag
  
  # to tibble
  y_df <- as_eml_tbl(y_list)
  inherits(y_df, 
           c("tbl_lp", "tbl_df", "tbl", "data.frame")) |>
    expect_true()
  expect_equal(
    colnames(y_df),
    c("level", "label", "text", "attributes"))  
  # check for similarity to earlier tibble
  expect_gte(nrow(y_df), nrow(x_df)) # this is _gte because we don't collapse `para` 
  expect_equal(ncol(x_df), ncol(y_df))

  # clean up
  unlink("EXAMPLE.Rmd")
  unlink("EXAMPLE.xml")
})

# test_that("xml documents can be losslessly converted to list and back", {
#   # read, convert, write
#   xml2::read_xml("testdata/meta_example.xml") |>
#     as_eml_list() |>
#     write_eml("testdata/TEST_meta_example.xml")
#   
#   # scan both xml files, compare for differences
#   x <- base::readLines("testdata/meta_example.xml")
#   y <- base::readLines("testdata/TEST_meta_example.xml")
#   expect_equal(x[-1 ], y[-1 ])
#  
#   # clean up
#   unlink("testdata/TEST_meta_example.xml")
# })
# 
# test_that("xml documents can be losslessly converted to tibble and back", {
#   # read, convert, write
#   xml2::read_xml("testdata/meta_example.xml") |>
#     as_eml_tibble() |>
#     write_eml("testdata/TEST_meta_example.xml")
#   
#   # scan both xml files, compare for differences
#   x <- base::readLines("testdata/meta_example.xml")
#   y <- base::readLines("testdata/TEST_meta_example.xml")
#   
#   # expect_equal(x[-1 ], y[-1 ]) # note this still needs work
#   
#   n_total <- length(x)
#   n_ok <- length(which(x == y))
#   difference <- abs(n_ok / n_total)
#   expect_gte(difference, 0.9) # >= 90% the same
#   
#   # clean up
#   unlink("testdata/TEST_meta_example.xml")
# })
# 
# test_that("xml documents can be losslessly converted to md and back", {
#   # read, convert, write
#   xml2::read_xml("testdata/meta_example.xml") |>
#     as_eml_chr() |>
#     write_eml("testdata/TEST_meta_example.xml")
#   
#   # scan both xml files, compare for differences
#   x <- base::readLines("testdata/meta_example.xml")
#   y <- base::readLines("testdata/TEST_meta_example.xml")
#   
#   # new header row has `encoding = "utf-8"`, missing from original
#   # otherwise these should be identical  
#   expect_equal(x[-1 ], y[-1 ])
#   
#   # clean up
#   unlink("testdata/TEST_meta_example.xml")
# })