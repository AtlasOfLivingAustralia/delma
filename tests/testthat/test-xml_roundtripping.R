test_that("xml documents can be losslessly converted to list and back", {
  # Note: this is basically all {xml2} code, so should be pretty safe
  x <- xml2::read_xml("testdata/meta_example.xml")
  y <- as_md_list(x)
  x2 <- as_md_xml(y)
  xml2::write_xml(x2, "testdata/TEST_meta_example.xml")
  
  # scan both xml files, compare for differences
  
  # unlink TEST xml file
})

test_that("xml documents can be losslessly converted to tibble and back", {
  x <- xml2::read_xml("testdata/meta_example.xml")
  # x |>
  #   parse_xml_to_list() |>
  #   parse_list_to_tibble() |>
  #   parse_tibble_to_chr()
  y <- as_md_tibble(x)
  x2 <- as_xml_document(y)
  xml2::write_xml(x2, "testdata/TEST_meta_example.xml")
  
  # scan both xml files, compare for differences
  
  # unlink TEST xml file
})

test_that("xml documents can be losslessly converted to md and back", {
  x <- xml2::read_xml("testdata/meta_example.xml")
  y <- as_md_chr(x)
  z <- parse_chr_to_tibble(y)
  x2 <- z |>
    parse_tibble_to_list() |>
    # note: <id> and <coreid> still missing attributes
    parse_list_to_xml()
  
  # x2 <- as_md_xml(y)
  xml2::write_xml(x2, "testdata/TEST_meta_example.xml")
  
  # scan both xml files, compare for differences
  
  # unlink TEST xml file

})