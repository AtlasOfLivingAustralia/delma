# Write an EML-formatted metadata document

`write_eml()` writes a `tibble`, `list` or `xml_document` to an EML
file. Note that EML files always have the file extension `.xml`.

## Usage

``` r
write_eml(x, file)
```

## Arguments

- x:

  Object of any class handled by `delma`; i.e. `tbl_df`, `list` or
  `xml_document`.

- file:

  Filename to write to

## Value

Doesn't return anything; called for the side-effect of writing the
specified EML file to disk.

## Examples

``` r
source_file <- system.file("extdata", 
                           "bionet_metadata.Rmd",
                           package = "delma") 
df <- read_md(source_file)
write_eml(df, "example.xml")
#> Warning: Duplicate heading detected in eml.
#> ℹ Defaulting to first item.
```
