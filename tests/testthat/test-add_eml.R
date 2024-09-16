test_that("add_eml() works properly", {
  x <- system.file("example_data", 
                   "README_md_example.md", 
                   package = "elm") |>
    read_md_chr() |>
    add_eml_row()
  expect_equal(x$label[[1]], "eml:eml") # q: is this what we'd expect?
  
  result <- as_md_list(x)
  expect_equal(length(result), 1)
  
  # q: test whether this renders properly to xml?
})