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



test_that("render_metadata() arguments work for R Markdown", {
  use_metadata_template("EXAMPLE.Rmd",
                        overwrite = TRUE,
                        quiet = TRUE)
  
  # fails with no args
  render_metadata() |>
    expect_error()
  
  # fails with no `input`
  render_metadata(output_file = "EXAMPLE.xml") |>
    expect_error()
  
  # fails when `input` doesn't exist
  render_metadata("something.file") |>
    expect_error()
  
  # returns 'meta.xml' when no `output_file` provided
  render_metadata("EXAMPLE.Rmd", overwrite = TRUE) |>
    expect_no_error()
  file.exists("meta.xml") |>
    expect_true()

  unlink("meta.xml")
  
  # setting a file name generates a file with that name, which is valid EML
  render_metadata("EXAMPLE.Rmd", 
                  output_file = "EXAMPLE.xml",
                  quiet = FALSE) |>
    expect_message()
  file.exists("EXAMPLE.xml") |>
    expect_true()
  
  # where file already exists (as created in prev test), default is to not overwrite 
  render_metadata("EXAMPLE.Rmd") |>
    expect_message()
  
  # check reimporting works
  x <- xml2::read_xml("EXAMPLE.xml")
  inherits(x, c("xml_document", "xml_node")) |>
    expect_true()
  # ditto but to tibble
  read_eml("EXAMPLE.xml") |>
    expect_no_error()
  
  # where not quiet, messages are given
  # first when overwrite = TRUE
  render_metadata("EXAMPLE.Rmd", 
                  output_file = "EXAMPLE.xml",
                  overwrite = TRUE,
                  quiet = FALSE) |>
    expect_message()

  render_metadata("EXAMPLE.Rmd", 
                  output_file = "EXAMPLE.xml",
                  overwrite = FALSE,
                  quiet = FALSE) |>
    expect_warning("File")  
  
  # ditto when overwrite = FALSE
  unlink("EXAMPLE.Rmd")
  unlink("EXAMPLE.xml")
})

test_that("render_metadata() arguments work for Quarto markdown", {
  use_metadata_template("EXAMPLE.qmd",
                        overwrite = TRUE,
                        quiet = TRUE)
  
  # fails with no args
  render_metadata() |>
    expect_error()
  
  # fails with no `input`
  render_metadata(output_file = "EXAMPLE.xml") |>
    expect_error()
  
  # fails when `input` doesn't exist
  render_metadata("something.file") |>
    expect_error()
  
  # returns 'meta.xml' when no `output_file` provided
  render_metadata("EXAMPLE.qmd",
                  overwrite = TRUE) |>
    expect_no_error()
  file.exists("meta.xml") |>
    expect_true()
  
  # where file already exists (as created in prev test), default is to not overwrite 
  render_metadata("EXAMPLE.qmd") |>
    expect_warning("File")
  unlink("meta.xml")
  
  # setting a file name generates a file with that name, which is valid EML
  render_metadata("EXAMPLE.qmd", 
                  output_file = "EXAMPLE.xml",
                  quiet = TRUE) |>
    expect_no_message()
  file.exists("EXAMPLE.xml") |>
    expect_true()
  # check reimporting works
  x <- xml2::read_xml("EXAMPLE.xml")
  inherits(x, c("xml_document", "xml_node")) |>
    expect_true()
  # ditto but to tibble
  read_eml("EXAMPLE.xml") |>
    expect_no_error()
  
  # where not quiet, messages are given
  # first when overwrite = TRUE
  render_metadata("EXAMPLE.qmd", 
                  output_file = "EXAMPLE.xml",
                  overwrite = TRUE,
                  quiet = FALSE) |>
    expect_message()
  
  render_metadata("EXAMPLE.qmd", 
                  output_file = "EXAMPLE.xml",
                  overwrite = FALSE,
                  quiet = FALSE) |>
    expect_warning("File")  
  
  # ditto when overwrite = FALSE
  unlink("EXAMPLE.qmd")
  unlink("EXAMPLE.xml")
})


test_that("check_metadata() works", {
  skip_if_offline()
  use_metadata_template("EXAMPLE.Rmd", 
                        overwrite = TRUE,
                        quiet = TRUE)
  render_metadata("EXAMPLE.Rmd", 
                  output_file = "EXAMPLE.xml",
                  quiet = TRUE)
  
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