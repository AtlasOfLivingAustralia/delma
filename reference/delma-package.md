# Convert metadata between markdown and EML

Ecological Metadata Language (EML) is a common framework for describing
ecological datasets so they can be shared and reused. `delma` supports
users to write metadata statements in R Markdown or Quarto Markdown for
greater transparency and ease-of-use, then convert them to EML for
efficient transfer.

## Functions

**Main functions**

- [`use_metadata_template()`](https://delma.ala.org.au/R/reference/use_metadata_template.md) -
  Create a template boilerplate metadata statement

- [`read_eml()`](https://delma.ala.org.au/R/reference/read_eml.md)/[`write_eml()`](https://delma.ala.org.au/R/reference/write_eml.md) -
  Read / write EML files to a `tibble`

- [`read_md()`](https://delma.ala.org.au/R/reference/read_md.md)/[`write_md()`](https://delma.ala.org.au/R/reference/write_md.md) -
  Read / write Rmd or qmd files to a `tibble`

- [`check_metadata()`](https://delma.ala.org.au/R/reference/check_metadata.md) -
  Run checks on an EML document

**Format manipulation**

- [`as_lp_tibble()`](https://delma.ala.org.au/R/reference/as_lp_tibble.md) -
  Convert metadata to class a `tibble` (class `tbl_lp`)

- [`as_eml_tibble()`](https://delma.ala.org.au/R/reference/as_eml_tibble.md) -
  Convert metadata to class a `tibble` (class `tbl_df`)

- [`as_eml_list()`](https://delma.ala.org.au/R/reference/as_eml_list.md) -
  Convert metadata to class `list`

- [`as_eml_xml()`](https://delma.ala.org.au/R/reference/as_eml_xml.md)-
  Convert metadata to class `xml_document`

## References

If you have any questions, comments or suggestions, please email
<support@ala.org.au>.

## See also

Useful links:

- <https://delma.ala.org.au>

- Report bugs at
  <https://github.com/AtlasOfLivingAustralia/delma/issues>

## Author

**Maintainer**: Martin Westgate <martin.westgate@csiro.au>

Authors:

- Shandiya Balasubramaniam <shandiya.balasubramaniam@csiro.au>

- Dax Kellie <dax.kellie@csiro.au>
