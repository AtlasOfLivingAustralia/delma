
<!-- README.md is generated from README.Rmd. Please edit that file -->

# delma <img src="man/figures/logo.png" align="right" style="margin: 0px 10px 0px 10px;" alt="" width="120"/><br>

## Overview

`delma` is a package for converting metadata statements written in
markdown, RMarkdown or Quarto markdown to [Ecological Metadata
Language](https://eml.ecoinformatics.org) (EML). It is named for a genus
of legless lizards that are endemic to Australia, whose name happens to
contain the letters ‘e’, ‘m’ and ‘l’.

The logo depicts a striped legless lizard (*Delma impar*) in the style
of the classic mobile game ‘snake’, a play on the observation that
*Delma* are often mistaken for snakes. It was drawn by Martin Westgate.

If you have any comments, questions or suggestions, please [contact
us](mailto:support@ala.org.au).

## Installation

This package is under active development, and is not yet available on
CRAN. You can install the latest development version from GitHub with:

``` r
install.packages("remotes")
remotes::install_github("AtlasOfLivingAustralia/delma")
```

Load the package:

``` r
library(delma)
```

## Basic usage

The primary use case for `delma` is to manipulate the format of metadata
statements for sharing biodiversity data. The first step is to create a
markdown file, and add any headings that you like that conform to the
EML standard. The header ‘level’ (i.e. number of `#`) is used to
designate the degree of nesting. If you don’t want to start from
scratch, you can use the example dataset provided:

``` r
library(dplyr)
use_metadata()
```

It is straightforward to export this to your working directory using
`write_md()`:

``` r
write_md(metadata_example, "metadata.md")
```

Once you are done, import it to R using `read_md()`. It will be stored
as a `tibble`:

``` r
x <- read_md("metadata.md")
x 
```

You can then export it as an xml file without any intermediate steps:

``` r
write_eml(x, "metadata.xml")
```

For a more detailed description of delma’s capabilities and methods, see
the ‘Quick start guide’ vignette.

## Citing `delma`

To generate a citation for the package version you are using, you can
run:

``` r
citation(package = "delma")
```

The current recommended citation is:

> Westgate MJ, Balasubramaniam S & Kellie D (2024) delma: Convert
> markdown files to EML. R Package version 0.1.0.
