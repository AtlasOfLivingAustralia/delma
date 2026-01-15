# Convert metadata to a lightparser `tibble`

Takes objects of class `tbl_df`, `list` or `xml_document` and converts
them to a tibble with a structure required by `lightparser`. Note that
`delma` represents these as an object of class `tbl_lp` for convenience.

## Usage

``` r
as_lp_tibble(x, ...)

# S3 method for class 'tbl_lp'
as_lp_tibble(x, ...)

# S3 method for class 'tbl_df'
as_lp_tibble(x, ...)

# S3 method for class 'list'
as_lp_tibble(x, ...)

# S3 method for class 'xml_document'
as_lp_tibble(x, ...)
```

## Arguments

- x:

  Object to be converted.

- ...:

  Other arguments, currently ignored.

## Value

An object of class `tbl_lp`, `tbl_df`, `tbl` and `data.frame`,
containing the following fields:

- `type` (chr) Whether that section is e.g. YAML, inline text, heading,
  or code block

- `label` (chr) The tag associated with a given code block (otherwise
  NA)

- `params` (list) Attributes of a code block

- `text` (list) Any text in that section

- `code` (list) Any code in that section

- `heading` (chr) For `type` = `heading`, the value of that heading

- `heading_level` (dbl) The heading level of that heading (i.e. number
  of `#`)

- `section` (chr) The heading this section sits within

## Examples

``` r
source_file <- system.file("extdata", 
                           "bionet_metadata.xml",
                           package = "delma")
xml_data <- xml2::read_xml(source_file)
as_lp_tibble(xml_data)
#> # A tibble: 132 × 8
#>    type    label params           text      code   heading heading_level section
#>    <chr>   <chr> <list>           <list>    <list> <chr>           <dbl> <chr>  
#>  1 yaml    NA    <named list [2]> <lgl [1]> <lgl>  NA                 NA NA     
#>  2 heading NA    <lgl [1]>        <chr [1]> <lgl>  eml                 1 eml    
#>  3 block   eml   <named list [2]> <NULL>    <chr>  NA                 NA eml    
#>  4 inline  NA    <lgl [1]>        <chr [2]> <lgl>  NA                 NA eml    
#>  5 heading NA    <lgl [1]>        <chr [1]> <lgl>  dataset             2 dataset
#>  6 inline  NA    <lgl [1]>        <chr [2]> <lgl>  NA                 NA dataset
#>  7 heading NA    <lgl [1]>        <chr [1]> <lgl>  altern…             3 altern…
#>  8 inline  NA    <lgl [1]>        <chr [3]> <lgl>  NA                 NA altern…
#>  9 heading NA    <lgl [1]>        <chr [1]> <lgl>  altern…             3 altern…
#> 10 inline  NA    <lgl [1]>        <chr [3]> <lgl>  NA                 NA altern…
#> # ℹ 122 more rows
```
