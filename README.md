
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

## Features

`elm` contains tools to:

- Import markdown files to R
- convert to `tibble`s, `eml` (list) format, or `xml`

## Citing galaxias

To generate a citation for the package version you are using, you can
run:

``` r
citation(package = "elm")
```

The current recommended citation is:

> Westgate MJ, Balasubramaniam S & Kellie D (2024) elm: Convert markdown
> files to EML. R Package version 0.1.0.9999.
