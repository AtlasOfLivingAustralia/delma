test_that("`as_lp_tibble()` works for class tbl_lp", {
  x <- system.file("extdata", 
                   "bionet_metadata.Rmd",
                   package = "delma") |>
    read_md() |>
    as_lp_tibble()
  inherits(x, 
           c("tbl_lp", "tbl_df", "tbl", "data.frame")) |>
    expect_true()
  expect_gte(nrow(x), 40)
})

# as_eml_tibble.list
test_that("`as_lp_tibble()` works for class list", {
  x <- system.file("extdata", 
                   "bionet_metadata.xml",
                   package = "delma") |>
    xml2::read_xml() |>
    as_eml_list()
  inherits(x, "list") |>
    expect_true()
  y <- as_lp_tibble(x)
  inherits(y, 
           c("tbl_lp", "tbl_df", "tbl", "data.frame")) |>
    expect_true()
  expect_gte(nrow(y), 40) 
})

test_that("as_lp_tibble() works for xml documents", {
  x <- system.file("extdata", 
                   "bionet_metadata.xml",
                   package = "delma") |>
    xml2::read_xml() |>
    as_lp_tibble()
  inherits(x, c("tbl_lp", "tbl_df", "tbl", "data.frame")) |>
    expect_true()
  expect_gte(nrow(x), 40)
})
