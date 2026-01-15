test_that("Rmd files from `use_metadata_template()` can be imported, written to EML, and back", {
  
  # set up a file for testing
  use_metadata_template("EXAMPLE.Rmd", 
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
  # That's useful; but actually read_lp() isn't exported, because
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
  y_df <- as_eml_tibble(y_list)
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

test_that("Quarto files `use_metadata_template()` can be imported, written to EML, and back", {
  skip_on_ci()
  skip_on_cran()
  
  # set up a file for testing
  use_metadata_template("EXAMPLE.Qmd", 
                        overwrite = TRUE,
                        quiet = TRUE)
  
  # first read using `lightparser` format
  x <- read_lp("EXAMPLE.Qmd")
  inherits(x, c("tbl_lp", "tbl_df", "tbl", "data.frame")) |>
    expect_true()
  expect_equal(
    colnames(x),
    c("type", "label", "params", "text", "code", "heading", "heading_level", "section"))
  expect_gte(nrow(x), 50)
  
  # to tibble
  x_df <- read_md("EXAMPLE.Qmd")
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
  y_df <- as_eml_tibble(y_list)
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
  unlink("EXAMPLE.Qmd")
  unlink("EXAMPLE.xml")
})

test_that("xml documents can be losslessly converted to Rmd and back", {
  # first read an example dataset
  # NOTE: this is created in `get_example_data.R`
  x <- system.file("extdata", 
                   "bionet_metadata.xml",
                   package = "delma") |>
    xml2::read_xml() 
  x |>
    inherits(c("xml_document", "xml_node")) |>
    expect_true()

  # convert to list
  x_list <- as_eml_list(x)
  x_list |>
    inherits("list") |>
    expect_true()
  expect_equal(length(x_list), 1)
  expect_equal(names(x_list), "eml")
  
  # to tibble
  x_tibble <- as_eml_tibble(x_list)
  x_tibble |>
    inherits(c("tbl_lp", "tbl_df", "tbl", "data.frame")) |>
    expect_true()
  expect_equal(
    colnames(x_tibble),
    c("level", "label", "text", "attributes")) 
  
  # to lightparser
  x_lp <- as_lp_tibble(x_tibble)
  x_lp |>
    inherits(c("tbl_lp", "tbl_df", "tbl", "data.frame")) |>
    expect_true()
  x_lp |>
    colnames() |>
    expect_equal(c("type", 
                   "label", 
                   "params", 
                   "text", 
                   "code", 
                   "heading", 
                   "heading_level", 
                   "section"))
  expect_gte(nrow(x_lp), 50)
  # ignored for now as largely an internal process to `write_md()`
  
  # # write to rmd
  rmd_file <- "testdata/TEST_RMD.Rmd"
  write_md(x_tibble, file = rmd_file)
  rmd_file |>
    file.exists() |>
    expect_true()
  # # possible to add tests here on the un-rendered Rmd file via `readLines()`
  # # not implemented yet as ability to re-import is more important
  
  # This is as far as we've gotten so far, for two reasons:
  # 1. It is unclear that anyone will need to take arbitrary xml and convert 
  #    it like this, as main function of delma is to go rmd > xml and not the
  #    reverse
  # 2. Odd content in the source xml can cause problems that are rare and 
  #    potentially not worth fixing; in this case there is an attribute called
  #    'function' which breaks R code (for obvious reasons)
    
  # # read data in again
  # y_tibble <- read_md("testdata/TEST_RMD.Rmd")
  ## NOTE: I'd quite strongly expect attributes to fail here, as I'm not sure
  ## we account properly for numeric suffixes in block labels
  # # write to xml
  # write_eml(y_tibble, "testdata/TEST_meta_example.xml")
  
  # # scan both xml files, compare for differences
  # x <- base::readLines("testdata/meta_example.xml")
  # y <- base::readLines("testdata/TEST_meta_example.xml")

  # expect_equal(x[-1 ], y[-1 ]) # note this still needs work

  # n_total <- length(x)
  # n_ok <- length(which(x == y))
  # difference <- abs(n_ok / n_total)
  # expect_gte(difference, 0.9) # >= 90% the same

  # clean up
  unlink(rmd_file)
  unlink("EXAMPLE.Qmd")
  unlink("EXAMPLE.xml")
  # unlink("testdata/TEST_meta_example.xml")
})