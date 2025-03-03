test_that("check_eml() works on a url", {
  skip("tests not ready")
  skip_if_offline()
  use_metadata("EXAMPLE.Rmd", overwrite = TRUE)
  
  # test <- read_md("EXAMPLE.Rmd")
  render_metadata("EXAMPLE.Rmd", "EXAMPLE.xml")
  check_metadata("EXAMPLE.xml")
  
  expect_condition({result <- check_eml(
    "https://collections.ala.org.au/ws/eml/dr368")}) 
  # unclear how to catch and check these messages
})