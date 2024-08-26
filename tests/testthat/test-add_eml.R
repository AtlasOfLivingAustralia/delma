test_that("add_eml() works properly", {
  # x <- read_md_chr("testdata/bionet_metadata.md")
  
  x <- system.file("example_data", "README_md_example.md", 
                      package = "elm") |>
    read_md_chr() |>
    add_eml_row()
  expect_equal(x$label[[1]], "`eml:eml`")
})