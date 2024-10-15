test_that("check_eml() works on a url", {
  skip("tests not ready")
  skip_if_offline()
  expect_condition({result <- check_eml(
    "https://collections.ala.org.au/ws/eml/dr368")}) 
  # unclear how to catch and check these messages
})