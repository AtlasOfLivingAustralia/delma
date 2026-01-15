# Write an example metadata statement to disk

This function places a metadata template at the address specified by
`"file"`, defaulting to `"metadata.Rmd"` in the working directory. The
template is built in such a way that standard rendering with `rmarkdown`
or Quarto to HTML or PDF will function; but also that it renders to
valid EML when processed using
[`read_md()`](https://delma.ala.org.au/R/reference/read_md.md) and
[`write_eml()`](https://delma.ala.org.au/R/reference/write_eml.md).

## Usage

``` r
use_metadata_template(file = NULL, overwrite = FALSE, quiet = FALSE)
```

## Arguments

- file:

  (string) A name for the resulting file, with either `.Rmd` or `.qmd`
  as a suffix. If `NULL` will default to `metadata.md`.

- overwrite:

  (logical) Should any existing file be overwritten? Defaults to
  `FALSE`.

- quiet:

  (logical) Should messages be suppressed? Defaults to `FALSE`.

## Value

Doesn't return anything to the workspace; called for the side-effect of
placing a metadata statement in the working directory.

## Examples

``` r
use_metadata_template("example.Rmd") 
#> ℹ Writing example.Rmd to top directory folder.
#> ✔ Writing example.Rmd to top directory folder. [11ms]
#> 
#> ℹ  Edit example.Rmd before converting to EML.
```
