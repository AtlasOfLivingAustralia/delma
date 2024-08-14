
<!-- README.md is generated from README.Rmd. Please edit that file -->

# elm

## Overview

`elm` is a package for import and type conversion of metadata
statements. It’s function is to enable users to store metadata in
markdown files, and convert them to EML.

If you have any comments, questions or suggestions, please [contact
us](mailto:support@ala.org.au).

## Installation

This package is under active development, and is not yet available on
CRAN. You can install the latest development version from GitHub with:

``` r
install.packages("remotes")
remotes::install_github("atlasoflivingaustralia/elm")
```

Load the package:

``` r
library(elm)
```

## Basic usage

The basic use case for `elm` is to import markdown to a tibble:

``` r
file <- system.file("example_data", "README_md_example.md", 
                    package = "elm")

x <- read_md_chr(file)
x 
#> # A tibble: 22 × 3
#>    level label                  text                                       
#>    <int> <chr>                  <chr>                                      
#>  1     1 alaDatasetMetadata     ""                                         
#>  2     2 dataResource           ""                                         
#>  3     3 title                  "An awesome dataset"                       
#>  4     2 description            "This data is the best. You should use it!"
#>  5     3 publicShortDescription ""                                         
#>  6     3 publicDescription      ""                                         
#>  7     3 technicalDescription   ""                                         
#>  8     3 dataQualityDescription ""                                         
#>  9     3 methodsDescription     ""                                         
#> 10     3 purpose                ""                                         
#> # ℹ 12 more rows
```

Here it can be examined and modified as required, then exported to xml:

``` r
write_md_xml(x, "metadata.xml")
```

The inverse operation - converting an `.xml` file with EML content into
`.md` - is also possible. This can work from an xml file in your working
directory, or from a UR:

``` r
y <- read_md_xml("https://collections.ala.org.au/ws/eml/dr368")
y
#> # A tibble: 50 × 4
#>    level label                text                                  attributes  
#>    <int> <chr>                <chr>                                 <list>      
#>  1     1 Eml                  <NA>                                  <named list>
#>  2     2 Dataset              <NA>                                  <lgl [1]>   
#>  3     3 Alternate Identifier 0101d74b-afc2-3b0f-817c-dc350d2a6fe4  <lgl [1]>   
#>  4     3 Alternate Identifier 10.15468/14jd9g                       <lgl [1]>   
#>  5     3 Alternate Identifier 0645ccdb-e001-4ab0-9729-51f1755e007e  <lgl [1]>   
#>  6     3 Alternate Identifier https://collections.ala.org.au/publi… <lgl [1]>   
#>  7     3 Title                NSW BioNet Atlas                      <lgl [1]>   
#>  8     3 Creator              <NA>                                  <lgl [1]>   
#>  9     4 Organization Name    Department of Planning, Industry and… <lgl [1]>   
#> 10     3 Metadata Provider    <NA>                                  <lgl [1]>   
#> # ℹ 40 more rows
```

``` r
write_md_chr(y, "metadata.md")
```

For a more detailed description of elm’s capabilities and methods, see
the ‘elm architecture’ vignette.

## Citing `elm`

To generate a citation for the package version you are using, you can
run:

``` r
citation(package = "elm")
```

The current recommended citation is:

> Westgate MJ, Balasubramaniam S & Kellie D (2024) elm: Convert markdown
> files to EML. R Package version 0.1.0.9999.
