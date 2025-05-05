test_that("use_metadata_template() creates an R Markdown template", {
  filename <- "EXAMPLE.Rmd"
  use_metadata_template(filename, 
                        overwrite = FALSE) |>
    expect_message()
  file.exists(filename) |>
    expect_true()
  unlink(filename)
})

test_that("use_metadata_template() creates an R Markdown template quietly", {
  filename <- "EXAMPLE.Rmd"
  # quiet
  use_metadata_template(filename, 
                        overwrite = FALSE,
                        quiet = TRUE) |>
    expect_no_message()
  file.exists(filename) |>
    expect_true()
  
  unlink(filename)
})

test_that("use_metadata_template() creates a quarto template", {
  filename <- "EXAMPLE.qmd"
  use_metadata_template(filename,
                        quiet = TRUE) |>
    expect_no_message()
  file.exists(filename) |>
    expect_true()
  unlink(filename)
})

test_that("use_metadata_template() only overwrites when told to do so", {
  filename <- "EXAMPLE.Rmd"
  use_metadata_template(filename, 
                        overwrite = FALSE,
                        quiet = TRUE)
  
  # do not overwrite
  use_metadata_template(filename) |>
    expect_message("File")
  
  # do overwrite
  use_metadata_template(filename,
                        overwrite = TRUE) |>
    expect_message("Overwriting")
  unlink(filename)
})


test_that("check_metadata() works", {
  skip_if_offline()
  use_metadata_template("EXAMPLE.Rmd", 
                        overwrite = TRUE,
                        quiet = TRUE)
  read_md("EXAMPLE.Rmd") |>
    write_eml("EXAMPLE.xml")

  # fails when no file supplied
  check_metadata() |>
    expect_error()
  
  # supplied schemas are used - does this make sense?
  
  # check parsers
  
  # check works properly when data supplied
  result <- check_metadata("EXAMPLE.xml", 
                           quiet = TRUE) |>
    expect_no_message()
  expect_lt(nrow(result), 1) # i.e. no errors
  
  # check message is returned when requested
  check_metadata("EXAMPLE.xml", 
                 quiet = FALSE) |>
    expect_message()
  
  unlink("EXAMPLE.Rmd")
  unlink("EXAMPLE.xml")
})