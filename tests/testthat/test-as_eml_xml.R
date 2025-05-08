test_that("`as_eml_xml()` works for class tbl_lp", {
  x <- system.file("extdata", 
                   "bionet_metadata.Rmd",
                   package = "delma") |>
    read_lp() |>
    as_eml_xml()
  inherits(x,
           c("xml_document", "xml_node")) |>
    expect_true()
})

test_that("`as_eml_xml()` works for class tbl_df", {
  x <- system.file("extdata", 
                   "bionet_metadata.Rmd",
                   package = "delma") |>
    read_md() |>
    as_eml_xml()
  inherits(x, 
           c("xml_document", "xml_node")) |>
    expect_true()
})

test_that("`as_eml_xml()` works for class list", {
  x <- system.file("extdata", 
                   "bionet_metadata.xml",
                   package = "delma") |>
    xml2::read_xml() |>
    as_eml_list()
  inherits(x, "list") |>
    expect_true()
  y <- as_eml_xml(x)
  inherits(y, 
           c("xml_document", "xml_node")) |>
    expect_true()
})