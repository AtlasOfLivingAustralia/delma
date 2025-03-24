# This is a script to import xsd files from GBIF, 
# and store them in inst/extdata

library(xml2)
library(tibble)
library(glue)
library(purrr)
library(here)

base_url <- "https://rs.gbif.org/schema/"
home <- read_html(base_url)

# get all links on this page
links <- home |>
  xml_find_all(".//a") |>
  xml_attrs() |>
  unlist()

# get all links that either:
  # end in .xsd, or
  # have string followed by "/" (i.e. subdirectories)
links <- links[grepl("^[[:alnum:]]+", links)] # not perfect regex, but works for now

# download xsd files
xsd_links <- links[grepl(".xsd$", links)]
downloads <- glue("{base_url}{xsd_links}")
map(downloads, \(a){
  download_xml(url = a,
               file = here("inst", "extdata", basename(a)))
  Sys.sleep(2)
}) |>
  invisible()

# get subdirectories
directories <- links[grepl("/$", links)]
directories <- directories[
  (directories %in% c("eml-2.2.0/", "eml-gbif-profile/"))]
                           
# make these into 'real' directories in the specified place
map(sub("/$", "", directories),
    \(a){
      here("inst", "extdata", a) |>
        dir.create()
        }) |>
  invisible()

# add a manual exception to only get version 1.3 of the gbif profile
dir.create(here("inst", "extdata", "eml-gbif-profile", "1.3"))
directories <- sub("eml-gbif-profile/", "eml-gbif-profile/1.3/", directories)

# for each url, download all files
map(directories, 
    \(a){
      link_tr <- glue("{base_url}{a}")
      links <- read_html(link_tr) |>
        xml_find_all(".//a") |>
        xml_attrs() |>
        unlist()
      map(links[grepl(".xsd$", links)],
          \(b){
            path <- glue("{here()}/inst/extdata/{a}{b}")
            url <- glue("{link_tr}{b}")
            download_xml(url = url, file = path)
            Sys.sleep(2)
          }) |>
        invisible()
    }) |>
  invisible()