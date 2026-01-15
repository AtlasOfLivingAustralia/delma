# Read an EML-formatted metadata document

`read_eml()` imports metadata from an EML file into the workspace as a
`tibble`.

## Usage

``` r
read_eml(file)
```

## Arguments

- file:

  Filename or URL to read from.

## Value

`read_eml()` returns an object of class `tbl_df`, `tbl` and `data.frame`
(i.e. a `tibble`).

## Examples

``` r
source_file <- system.file("extdata", 
                           "bionet_metadata.xml",
                           package = "delma")
df <- read_eml(source_file)
```
