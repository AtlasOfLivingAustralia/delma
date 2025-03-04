test_that("check_eml() works on a url", {
  skip_if_offline()
  use_metadata("EXAMPLE.Rmd", overwrite = TRUE)
  # test <- read_md("EXAMPLE.Rmd")
  render_metadata("EXAMPLE.Rmd", "EXAMPLE.xml")
  result <- check_metadata("EXAMPLE.xml", quiet = TRUE)
  expect_lt(nrow(result), 1) # i.e. no errors
  
  # expect_condition({result <- check_metadata(
  #   "https://collections.ala.org.au/ws/eml/dr368")}) 
})