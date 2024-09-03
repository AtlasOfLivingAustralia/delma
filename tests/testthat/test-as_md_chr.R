# as_md_chr.tbl_df

# as_md_chr.list

# as_md_chr.xml_document
test_that("as_md_chr() converts xml correctly", {
  x <- read_md_xml("https://collections.ala.org.au/ws/eml/dr368")
  y <- as_md_chr(x)
  expect_null(names(y))
  expect_equal(class(y), "character")
  expect_true(grepl("^<h1 schemaLocation", y[1]))
  expect_gte(length(y), 100)
})