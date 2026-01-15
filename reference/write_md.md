# Write a markdown-formatted metadata document

`write_md()` creates an `Rmd` or `Qmd` file from an EML file.

## Usage

``` r
write_md(x, file)
```

## Arguments

- x:

  Object of any class handled by `delma`; i.e. `tbl_lp,` `tbl_df`,
  `list` or `xml_document`.

- file:

  Filename to write to. Must be either `.md`, `.Rmd` or `.qmd` file.

## Value

Doesn't return anything; called for the side-effect of writing the
specified markdown file to disk.

## Details

Similar to
[`read_md()`](https://delma.ala.org.au/R/reference/read_md.md),
`write_md()` is considerably less generic than most `write_` functions.
If `x` is an `xml_document` this should convert seamlessly; but lists or
tibbles that have been manually formatted require care. Internally,
`write_md()` calls
[lightparser::combine_tbl_to_file](https://thinkr-open.github.io/lightparser/reference/combine_tbl_to_file.html).

## Examples

``` r
source_file <- system.file("extdata", 
                           "bionet_metadata.xml",
                           package = "delma")
df <- read_eml(source_file)
write_md(df, "example.Rmd")
```
