# Read markdown-formatted metadata

`read_md()` imports metadata from a markdown file into the workspace as
a `tibble`.

## Usage

``` r
read_md(file)
```

## Arguments

- file:

  Filename to read from. Must be either `.Rmd` or `.qmd` file.

## Value

`read_md()` returns an object of class `tbl_df`, `tbl` and `data.frame`
(i.e. a `tibble`).

## Details

`read_md()` is unusual in that it calls
[`rmarkdown::render()`](https://pkgs.rstudio.com/rmarkdown/reference/render.html)
or
[`quarto::quarto_render()`](https://quarto-dev.github.io/quarto-r/reference/quarto_render.html)
internally to ensure code blocks and snippets are parsed correctly. This
ensures dynamic content is rendered correctly in the resulting `EML`
document, but makes this function considerably slower than a standard
import function. Conceptually, therefore, it is closer to a renderer
with output type `tibble` than a traditional `read_` function.

This approach has one unusual consequence; it prevents 'round-tripping'
of embedded code. That is, dynamic content in code snippets within the
metadata statement is rendered to plain text in `EML.` If that `EML`
document is later re-imported to `Rmd` using
[`read_eml()`](https://delma.ala.org.au/R/reference/read_eml.md) and
[`write_md()`](https://delma.ala.org.au/R/reference/write_md.md),
formerly dynamic content will be shown as plain text.

Internally, `read_md()` calls
[`lightparser::split_to_tbl()`](https://thinkr-open.github.io/lightparser/reference/split_to_tbl.html).

## Examples

``` r
source_file <- system.file("extdata", 
                           "bionet_metadata.Rmd",
                           package = "delma")
read_md(source_file)
#> # A tibble: 64 × 4
#>    level label               text      attributes
#>    <dbl> <chr>               <list>    <list>    
#>  1     1 eml:eml             <lgl [1]> <lgl [1]> 
#>  2     2 dataset             <lgl [1]> <lgl [1]> 
#>  3     3 alternateIdentifier <chr [1]> <lgl [1]> 
#>  4     3 alternateIdentifier <chr [1]> <lgl [1]> 
#>  5     3 alternateIdentifier <chr [1]> <lgl [1]> 
#>  6     3 alternateIdentifier <chr [1]> <lgl [1]> 
#>  7     3 title               <chr [1]> <lgl [1]> 
#>  8     3 creator             <lgl [1]> <lgl [1]> 
#>  9     4 organizationName    <chr [1]> <lgl [1]> 
#> 10     4 address             <lgl [1]> <lgl [1]> 
#> # ℹ 54 more rows
```
