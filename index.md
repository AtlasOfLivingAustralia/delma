# delma 

## Overview

`delma` is a package for converting metadata statements written in R
Markdown or Quarto markdown to [Ecological Metadata
Language](https://eml.ecoinformatics.org) (EML). Ecological Metadata
Language (EML) is a common framework for describing ecological datasets
so they can be shared and reused. `delma` supports users to write
metadata statements in R Markdown or Quarto markdown for greater
transparency and ease-of-use, then convert them to EML for efficient
transfer.

`delma` is named for a genus of legless lizards that are endemic to
Australia, whose name happens to contain the letters ‘e’, ‘m’ and ‘l’.

The logo depicts a striped legless lizard (*Delma impar*) in the style
of the classic mobile game ‘snake’, a play on the observation that
*Delma* are often mistaken for snakes. It was designed by [Martin
Westgate](https://martinwestgate.com).

If you have any comments, questions or suggestions, please [contact
us](mailto:support@ala.org.au).

## Installation

You can install from CRAN using:

``` r
install.packages("delma")
```

Alternatively, you can install the latest development version from
GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("AtlasOfLivingAustralia/delma")
```

Load the package:

``` r
library(delma)
```

## Basic usage

The primary use case for `delma` is to build metadata statements for
sharing biodiversity data. To get started, create a basic template with
[`use_metadata_template()`](https://delma.ala.org.au/R/reference/use_metadata_template.md).

``` r
use_metadata_template("my_metadata_statement.Rmd")
```

Here is a short, minimal example of what a metadata template looks like.

``` R
---
title: A Descriptive Title for your Dataset in Title Case
output: html_document
date: 2025-02-01
---

## Dataset

### Title

### Creator

#### Individual Name

##### Given Name
Firstname

##### Surname
Lastname

#### Address
```

Users can add any additional headings to their metadata statement that
conform with EML standard. The header level (i.e. the number of `#`)
designates the degree of nesting.

This document can be knit like any other R Markdown or Quarto document
(using either the ‘knit’ button in RStudio or `rmarkdown::knit()`) to
the format defined in the yaml section, which defaults to
`html_document`.

To convert an R Markdown metadata statement to EML, use:

``` r
render_metadata("my_metadata_statement.Rmd")
```

This reformats our metadata in EML and saves it as a file. EML documents
are saved as `.xml` files.

``` R
<?xml version="1.0" encoding="UTF-8"?>
<eml:eml xmlns:eml="https://eml.ecoinformatics.org/eml-2.2.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" packageId="the-doi-for-this-archive" system="https://doi.org" scope="system" xsi:schemaLocation="http://rs.gbif.org/schema/eml-gbif-profile/1.3/eml-gbif-profile.xsd">
  <dataset>
    <title>A Descriptive Title for your Dataset in Title Case</title>
    <creator>
      <individualName>
        <givenName>Firstname</givenName>
        <surName>Lastname</surName>
      </individualName>
    </creator>
  </dataset>
</eml:eml>
```

To check that your document is formatted in accordance with the EML
standard, use:

``` r
check_metadata("metadata.xml")
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

> Westgate MJ, Balasubramaniam S & Kellie D (2025) Convert R Markdown
> and Quarto documents to Ecological Metadata Language. R Package
> version 0.1.1.
