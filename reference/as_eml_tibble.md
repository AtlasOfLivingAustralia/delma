# Convert metadata to a `tibble`

Takes objects of class `list` or `xml_document` and converts them to a
tibble with a particular structure, designed for storing nested data.
Tibbles are required because attributes are stored as list-columns,
which are not supported by class `data.frame`.

## Usage

``` r
as_eml_tibble(x, ...)

# S3 method for class 'tbl_df'
as_eml_tibble(x, ...)

# S3 method for class 'tbl_lp'
as_eml_tibble(x, ...)

# S3 method for class 'list'
as_eml_tibble(x, ...)

# S3 method for class 'xml_document'
as_eml_tibble(x, ...)
```

## Arguments

- x:

  Object to be converted

- ...:

  Other arguments, currently ignored

## Value

An object of class `tbl_df`, `tbl` and `data.frame`, containing the
following fields:

- `level` (int) gives the nestedness level of the node/heading in
  question

- `label` (chr) the `xml` tag

- `text` (chr) Any text stored within that tag

- `attributes` (list) Any attributes for that tag

## Examples

``` r
source_file <- system.file("extdata", 
                           "bionet_metadata.xml",
                           package = "delma")
xml_data <- xml2::read_xml(source_file)
as_eml_tibble(xml_data)
#> # A tibble: 63 × 4
#>    level label               text      attributes      
#>    <dbl> <chr>               <list>    <list>          
#>  1     1 eml                 <chr [1]> <named list [8]>
#>  2     2 dataset             <chr [1]> <lgl [1]>       
#>  3     3 alternateIdentifier <chr [1]> <lgl [1]>       
#>  4     3 alternateIdentifier <chr [1]> <lgl [1]>       
#>  5     3 alternateIdentifier <chr [1]> <lgl [1]>       
#>  6     3 alternateIdentifier <chr [1]> <lgl [1]>       
#>  7     3 title               <chr [1]> <named list [1]>
#>  8     3 creator             <chr [1]> <lgl [1]>       
#>  9     4 organizationName    <chr [1]> <lgl [1]>       
#> 10     4 address             <chr [1]> <lgl [1]>       
#> # ℹ 53 more rows
```
