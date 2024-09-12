test_that("add_eml() works properly", {
  x <- system.file("example_data", 
                   "README_md_example.md", 
                   package = "elm") |>
    read_md_chr() |>
    add_eml_row()
  expect_equal(x$label[[1]], "`eml:eml`")
  
  as_md_list(x) |> str()
  
  write_md_xml(x, "TEST.xml")
  xml2::read_xml("TEST.xml")
})