test_that("check_eml() works on a url", {
  skip_if_offline()
  use_metadata("EXAMPLE.Rmd", 
               overwrite = TRUE,
               quiet = TRUE)
  render_metadata("EXAMPLE.Rmd", 
                  output_file = "EXAMPLE.xml",
                  quiet = TRUE)
  result <- check_metadata("EXAMPLE.xml", 
                           quiet = TRUE)
  expect_lt(nrow(result), 1) # i.e. no errors
  unlink("EXAMPLE.Rmd")
  unlink("EXAMPLE.xml")
})