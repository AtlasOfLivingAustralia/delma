# Check validity of a metadata statement

In the Darwin Core standard, metadata statements are mandatory and must
be provided in Ecological Metadata Language (EML) in a file called
`eml.xml`. This function applies a series of checks designed by GBIF to
check the structure of the specified xml document for consistency with
the standard. Note, however, that this function doesn't check the
*content* of those files, meaning a file could be structurally sound and
still be lacking critical information.

## Usage

``` r
check_metadata(file = NULL, schema = NULL, quiet = FALSE)
```

## Arguments

- file:

  An EML file to check Can be either local or a URL.

- schema:

  Either `NULL` (the default) to compare to the GBIF profile; or a URL
  to a valid schema (passed internally to
  [xml2::read_xml](http://xml2.r-lib.org/reference/read_xml.md)).

- quiet:

  (logical) Should messages be hidden? Defaults to `FALSE`.

## Value

Invisibly returns a tibble showing parsed errors; or an empty tibble if
no errors are identified.

## Details

This function uses local versions of `dc.xsd`, `eml-gbif-profile.xsd`
and `eml.xsd` downloaded from
`http://rs.gbif.org/schema/eml-gbif-profile/1.3/` on 2024-09-25.

## Examples

``` r
source_file <- system.file("extdata", 
                           "bionet_metadata.xml",
                           package = "delma")
check_metadata(source_file)
#> 
#> ── `check_metadata()` result: ──
#> 
#> ── Error in `eml` from eml://ecoinformatics.org/eml-2.1.1 
#> No matching global declaration available for the validation root.
#> 
```
