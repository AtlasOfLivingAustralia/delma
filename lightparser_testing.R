file <- system.file("extdata",
                    "metadata_example.Rmd",
                    package = "delma")
x <- read_md(file)

purl(file)

# parse a code block; in this case the attributes to EML
# `eml` name is the name of the code block
glue_collapse(x$code[[3]], sep = "\n") |> parse(text = _) |> eval()

# exception for title: parse yaml instead
x$params[[1]]$title

# Challenge: it is difficult to get a file that works for all instances.
# e.g. we don't want to render our eml tags to html; but we need them for eml.
# we can import them as text, but then we have to rerun our code blocks
# This *might* work, but *might not*

# at the moment, I suspect that running code in the directory of the
# document will allow us to run simple code blocks, e.g. getting number 
# of rows or columns. Further, this does seem to be a useful feature.
# But it hasn't been tested yet.

# possible workflow:
  # copy source file to temporary location
  # change new file to `output: md_document`
  # render this new document with knitr::knit (or call to Quarto somehow?)
  # import new doc with lightparser::split_to_tbl() -> x
  # import source doc with lightparser::split_to_tbl() -> y
  # use x as base, add non-rendered code-blocks as attributes

# the above method avoids us duplicating knitr code in a less reproducible way,
# while still preserving non-rendered content using code blocks. The latter 
# feature is desirable because it makes attributes visible in a more R-like
# way than using <h1> etc, or just removing them completely (current solution).

# ok let's try that

# find file
file <- system.file("extdata",
                    "metadata_example.Rmd",
                    package = "delma")


# detect unexported code blocks somehow
  # could look for echo=FALSE?
  # or look for code blocks in `source_tibble` but not `md_tibble`