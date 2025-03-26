test_that("`as_eml_xml()` works for class tbl_lp", {
  x <- read_lp("testdata/bionet_metadata.Rmd") |>
    as_eml_xml()
  inherits(x,
           c("xml_document", "xml_node")) |>
    expect_true()
})

test_that("`as_eml_xml()` works for class tbl_df", {
  x <- read_md("testdata/bionet_metadata.Rmd") |>
    as_eml_xml()
  inherits(x, 
           c("xml_document", "xml_node")) |>
    expect_true()
})

test_that("`as_eml_xml()` works for class list", {
  x <- xml2::read_xml("testdata/bionet_metadata.xml") |>
    as_eml_list()
  inherits(x, "list") |>
    expect_true()
  y <- as_eml_xml(x)
  inherits(y, 
           c("xml_document", "xml_node")) |>
    expect_true()
})