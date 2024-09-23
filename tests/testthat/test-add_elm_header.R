test_that("add_elm_header() works properly", {
  x <- system.file("example_data", 
                   "README_md_example.md", 
                   package = "elm") |>
    read_elm_md() |>
    add_elm_header()
  expect_equal(x$label[[1]], "eml:eml") # q: is this what we'd expect?
  
  result <- as_elm_list(x)
  expect_equal(length(result), 1)
  
  # q: test whether this renders properly to xml?
  
  # try another check that is known to cause bugs
  y <- read_elm("testdata/bionet_metadata.md") |>
    add_elm_header()
  # check for bug present in earlier versions - this function changes 
  # all entries of level to `1`
  expect_false(all(y$level == 1)) 
  expect_no_error({as_elm_list(y)})
})
