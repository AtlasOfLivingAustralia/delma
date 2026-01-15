# Convert metadata to a `list`

Takes an object of class `xml_document` or `tibble`, and converts it to
a `list`. When converting from an `xml_document`, this is simply a
wrapper for `xml2::as_list()`

## Usage

``` r
as_eml_list(x, ...)

# S3 method for class 'tbl_lp'
as_eml_list(x, ...)

# S3 method for class 'tbl_df'
as_eml_list(x, ...)

# S3 method for class 'list'
as_eml_list(x, ...)

# S3 method for class 'xml_document'
as_eml_list(x, ...)
```

## Arguments

- x:

  Object to be converted

- ...:

  Other arguments, currently ignored

## Value

A list, where both the nested structure of the XML/md and the attributes
of XML nodes, are preserved.

## Examples

``` r
source_file <- system.file("extdata", 
                           "bionet_metadata.Rmd",
                           package = "delma")
df <- read_md(source_file)
as_eml_list(df) |> str()
#> Warning: Duplicate heading detected in eml.
#> ℹ Defaulting to first item.
#> List of 1
#>  $ eml:eml:List of 2
#>   ..$ dataset           :List of 18
#>   .. ..$ alternateIdentifier:List of 1
#>   .. .. ..$ : chr "0101d74b-afc2-3b0f-817c-dc350d2a6fe4"
#>   .. ..$ alternateIdentifier:List of 1
#>   .. .. ..$ : chr "10.15468/14jd9g"
#>   .. ..$ alternateIdentifier:List of 1
#>   .. .. ..$ : chr "0645ccdb-e001-4ab0-9729-51f1755e007e"
#>   .. ..$ alternateIdentifier:List of 1
#>   .. .. ..$ : chr "https://collections.ala.org.au/public/show/dr368"
#>   .. ..$ title              :List of 1
#>   .. .. ..$ : chr "NSW BioNet Atlas"
#>   .. ..$ creator            :List of 2
#>   .. .. ..$ organizationName:List of 1
#>   .. .. .. ..$ :List of 1
#>   .. .. .. .. ..$ para:List of 1
#>   .. .. .. .. .. ..$ : chr "Department of Planning, Industry and Environment representing the State of New South Wales"
#>   .. .. ..$ address         : list()
#>   .. ..$ metadataProvider   :List of 2
#>   .. .. ..$ organizationName:List of 1
#>   .. .. .. ..$ :List of 1
#>   .. .. .. .. ..$ para:List of 1
#>   .. .. .. .. .. ..$ : chr "Department of Planning, Industry and Environment representing the State of New South Wales"
#>   .. .. ..$ address         : list()
#>   .. ..$ associatedParty    :List of 4
#>   .. .. ..$ organizationName     :List of 1
#>   .. .. .. ..$ : chr "Atlas of Living Australia"
#>   .. .. ..$ address              :List of 5
#>   .. .. .. ..$ deliveryPoint     :List of 1
#>   .. .. .. .. ..$ : chr "CSIRO Ecosystems Services"
#>   .. .. .. ..$ city              :List of 1
#>   .. .. .. .. ..$ : chr "Canberra"
#>   .. .. .. ..$ administrativeArea:List of 1
#>   .. .. .. .. ..$ : chr "ACT"
#>   .. .. .. ..$ postalCode        :List of 1
#>   .. .. .. .. ..$ : chr "2601"
#>   .. .. .. ..$ country           :List of 1
#>   .. .. .. .. ..$ : chr "Australia"
#>   .. .. ..$ electronicMailAddress:List of 1
#>   .. .. .. ..$ : chr "info@ala.org.au"
#>   .. .. ..$ role                 :List of 1
#>   .. .. .. ..$ : chr "distributor"
#>   .. ..$ associatedParty    :List of 3
#>   .. .. ..$ organizationName:List of 1
#>   .. .. .. ..$ : chr "Office of Environment & Heritage"
#>   .. .. ..$ address         : list()
#>   .. .. ..$ role            :List of 1
#>   .. .. .. ..$ : chr "originator"
#>   .. ..$ pubDate            :List of 1
#>   .. .. ..$ : chr "2023-04-27"
#>   .. ..$ language           :List of 1
#>   .. .. ..$ : chr "English"
#>   .. ..$ abstract           :List of 1
#>   .. .. ..$ para:List of 1
#>   .. .. .. ..$ :List of 1
#>   .. .. .. .. ..$ para:List of 1
#>   .. .. .. .. .. ..$ : chr "Records from DPIE’s NSW BioNet Atlas database of flora and fauna sightings. Includes records from other custodi"| __truncated__
#>   .. ..$ intellectualRights :List of 5
#>   .. .. ..$ para:List of 1
#>   .. .. .. ..$ ulink: list()
#>   .. .. .. .. ..- attr(*, "url")= chr [1:2] "International" "International"
#>   .. .. ..$ para:List of 1
#>   .. .. .. ..$ :List of 1
#>   .. .. .. .. ..$ para:List of 1
#>   .. .. .. .. .. ..$ : chr "BioNet Species Sightings occurrence data held by the NSW Office of Environment and Heritage (OEH). The BioNet r"| __truncated__
#>   .. .. ..$ para:List of 1
#>   .. .. .. ..$ ulink:List of 1
#>   .. .. .. .. ..$ citetitle: chr [1:2] NA NA
#>   .. .. ..$ para:List of 1
#>   .. .. .. ..$ ulink:List of 1
#>   .. .. .. .. ..$ citetitle: chr [1:2] NA NA
#>   .. .. ..$ para: list()
#>   .. ..$ distribution       :List of 1
#>   .. .. ..$ online:List of 1
#>   .. .. .. ..$ url:List of 1
#>   .. .. .. .. ..$ : chr "https://collections.ala.org.au/public/show/dr368"
#>   .. ..$ coverage           : list()
#>   .. ..$ purpose            :List of 1
#>   .. .. ..$ para: list()
#>   .. ..$ contact            :List of 3
#>   .. .. ..$ organizationName     :List of 1
#>   .. .. .. ..$ : chr "Atlas of Living Australia"
#>   .. .. ..$ address              :List of 5
#>   .. .. .. ..$ deliveryPoint     :List of 1
#>   .. .. .. .. ..$ : chr "CSIRO Ecosystems Services"
#>   .. .. .. ..$ city              :List of 1
#>   .. .. .. .. ..$ : chr "Canberra"
#>   .. .. .. ..$ administrativeArea:List of 1
#>   .. .. .. .. ..$ : chr "ACT"
#>   .. .. .. ..$ postalCode        :List of 1
#>   .. .. .. .. ..$ : chr "2601"
#>   .. .. .. ..$ country           :List of 1
#>   .. .. .. .. ..$ : chr "Australia"
#>   .. .. ..$ electronicMailAddress:List of 1
#>   .. .. .. ..$ : chr "info@ala.org.au"
#>   .. ..$ methods            : list()
#>   ..$ additionalMetadata:List of 1
#>   .. ..$ metadata:List of 1
#>   .. .. ..$ gbif:List of 3
#>   .. .. .. ..$ dateStamp     :List of 1
#>   .. .. .. .. ..$ : chr "2023-04-27T01:00:07"
#>   .. .. .. ..$ hierarchyLevel:List of 1
#>   .. .. .. .. ..$ : chr "dataset"
#>   .. .. .. ..$ citation      :List of 1
#>   .. .. .. .. ..$ :List of 1
#>   .. .. .. .. .. ..$ para:List of 1
#>   .. .. .. .. .. .. ..$ : chr "BioNet Species Sightings occurrence data held by the NSW Office of Environment and Heritage (OEH). The BioNet r"| __truncated__
```
