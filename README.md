
<!-- README.md is generated from README.Rmd. Please edit that file -->

# paperbark <img src="man/figures/logo.png" align="right" style="margin: 0px 10px 0px 10px;" alt="" width="120"/><br>

## Overview

`paperbark` is a package for import and type conversion of metadata
statements. Its purpose is to enable users to store metadata in markdown
files, and convert them to EML. It is named for the peeling growth form
displayed by a number of Australian plant species. The logo was drawn by
Martin Westgate, and shows the flower of the swamp paperbark *Melaleuca
ericifolia*.

If you have any comments, questions or suggestions, please [contact
us](mailto:support@ala.org.au).

## Installation

This package is under active development, and is not yet available on
CRAN. You can install the latest development version from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("AtlasOfLivingAustralia/paperbark")
```

Load the package:

``` r
library(paperbark)
```

## Basic usage

The primary use case for `paperbark` is to create metadata statements
for sharing biodiversity data. You can create a blank file by calling
`use_metadata()`. When you open the resulting file, it will show a
markdown file with some pre-chosen headings, like this:

    #>  [1] "<h1 xmlns:d=\"eml://ecoinformatics.org/dataset-2.1.0\" xmlns:eml=\"eml://ecoinformatics.org/eml-2.1.1\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:dc=\"http://purl.org/dc/terms/\" xsi:schemaLocation=\"eml://ecoinformatics.org/eml-2.1.1 http://rs.gbif.org/schema/eml-gbif-profile/1.3/eml-gbif-profile.xsd\" system=\"R-elm-package\" scope=\"system\" xml:lang=\"en\">eml:eml</h1>"
    #>  [2] ""                                                                                                                                                                                                                                                                                                                                                                                                           
    #>  [3] ""                                                                                                                                                                                                                                                                                                                                                                                                           
    #>  [4] ""                                                                                                                                                                                                                                                                                                                                                                                                           
    #>  [5] "## Dataset"                                                                                                                                                                                                                                                                                                                                                                                                 
    #>  [6] ""                                                                                                                                                                                                                                                                                                                                                                                                           
    #>  [7] "### Title"                                                                                                                                                                                                                                                                                                                                                                                                  
    #>  [8] ""                                                                                                                                                                                                                                                                                                                                                                                                           
    #>  [9] "A Sentence Giving Your Dataset Title In Title Case"                                                                                                                                                                                                                                                                                                                                                         
    #> [10] ""

You can then populate your metadata statement with whatever information
is needed to support effective re-use. You can add further headings as
you wish, presuming that they follow the EML standard. The header
‘level’ (i.e. number of `#`) is used to designate the degree of nesting.

Once you are done, import it to R using `read_md()`. It will be stored
as a `tibble`:

``` r
x <- read_md("metadata.md")
x 
```

    #> # A tibble: 29 × 4
    #>    level label                  text                                attributes  
    #>    <dbl> <chr>                  <chr>                               <list>      
    #>  1     1 eml:eml                ""                                  <named list>
    #>  2     2 dataset                 <NA>                               <lgl [1]>   
    #>  3     3 title                   <NA>                               <lgl [1]>   
    #>  4     4 <NA>                   "An awesome dataset"                <NULL>      
    #>  5     2 description             <NA>                               <lgl [1]>   
    #>  6     3 <NA>                   "This data is the best. You should… <NULL>      
    #>  7     3 publicShortDescription  <NA>                               <lgl [1]>   
    #>  8     3 publicDescription       <NA>                               <lgl [1]>   
    #>  9     3 technicalDescription    <NA>                               <lgl [1]>   
    #> 10     3 dataQualityDescription  <NA>                               <lgl [1]>   
    #> # ℹ 19 more rows

You can then export it as an xml file without any intermediate steps:

``` r
write_eml(x, "metadata.xml")
```

For a more detailed description of paperbark’s capabilities and methods,
see the ‘Quick start guide’ vignette.

## Citing `paperbark`

To generate a citation for the package version you are using, you can
run:

``` r
citation(package = "paperbark")
```

The current recommended citation is:

> Westgate MJ, Balasubramaniam S & Kellie D (2024) paperbark: Convert
> markdown files to EML. R Package version 0.1.0.
