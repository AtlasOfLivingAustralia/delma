
<!-- README.md is generated from README.Rmd. Please edit that file -->

# elm <img src="man/figures/logo.png" align="right" style="margin: 0px 10px 0px 10px;" alt="" width="120"/><br>

## Overview

`elm` is a package for import and type conversion of metadata
statements. Its purpose is to enable users to store metadata in markdown
files, and convert them to EML.

If you have any comments, questions or suggestions, please [contact
us](mailto:support@ala.org.au).

## Installation

This package is under active development, and is not yet available on
CRAN. You can install the latest development version from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("AtlasOfLivingAustralia/elm")
```

Load the package:

``` r
library(elm)
```

## Basic usage

The primary use case for `elm` is to import metadata into a tibble. This
can be done from a markdown file:

``` r
x <- system.file("example_data", 
                 "README_md_example.md", 
                 package = "elm") |>
  read_md()

x 
#> # A tibble: 28 × 4
#>    level label                  text                                  attributes
#>    <dbl> <chr>                  <chr>                                 <list>    
#>  1     2 dataset                <NA>                                  <lgl [1]> 
#>  2     3 title                  <NA>                                  <lgl [1]> 
#>  3     4 <NA>                   An awesome dataset                    <NULL>    
#>  4     2 description            <NA>                                  <lgl [1]> 
#>  5     3 <NA>                   This data is the best. You should us… <NULL>    
#>  6     3 publicShortDescription <NA>                                  <lgl [1]> 
#>  7     3 publicDescription      <NA>                                  <lgl [1]> 
#>  8     3 technicalDescription   <NA>                                  <lgl [1]> 
#>  9     3 dataQualityDescription <NA>                                  <lgl [1]> 
#> 10     3 methodsDescription     <NA>                                  <lgl [1]> 
#> # ℹ 18 more rows
```

or an xml file:

``` r
read_eml("https://collections.ala.org.au/ws/eml/dr368")
#> # A tibble: 85 × 4
#>    level label                text                                  attributes  
#>    <int> <chr>                <chr>                                 <list>      
#>  1     1 Eml                  <NA>                                  <named list>
#>  2     2 Dataset              <NA>                                  <named list>
#>  3     3 Alternate Identifier <NA>                                  <lgl [1]>   
#>  4     4 <NA>                 0101d74b-afc2-3b0f-817c-dc350d2a6fe4  <lgl [1]>   
#>  5     4 <NA>                 10.15468/14jd9g                       <lgl [1]>   
#>  6     4 <NA>                 0645ccdb-e001-4ab0-9729-51f1755e007e  <lgl [1]>   
#>  7     4 <NA>                 https://collections.ala.org.au/publi… <lgl [1]>   
#>  8     3 Title                <NA>                                  <named list>
#>  9     4 <NA>                 NSW BioNet Atlas                      <lgl [1]>   
#> 10     3 Creator              <NA>                                  <named list>
#> # ℹ 75 more rows
```

Here it can be examined and modified as required, then exported to
either format:

``` r
write_eml(x, "metadata.xml")
write_md(x, "metadata.md")
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
> files to EML. R Package version 0.1.0.
