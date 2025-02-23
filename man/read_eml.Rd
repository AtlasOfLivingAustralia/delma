% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_eml.R
\name{read_eml}
\alias{read_eml}
\alias{write_eml}
\title{Read or write EML-formatted metadata}
\usage{
read_eml(file)

write_eml(x, file)
}
\arguments{
\item{file}{Filename to read from or write to. In the case of \code{read_eml()},
can alternatively be a url to a valid EML document.}

\item{x}{Object of any class handled by \code{delma}; i.e. \code{character},
\code{tbl_df}, \code{list} or \code{xml_document}.}
}
\value{
\code{read_eml()} returns an object of class \code{tbl_df}, \code{tbl} and
\code{data.frame} (i.e. a \code{tibble}). \code{write_eml()} doesn't return anything, and
is called for the side-effect of writing the specified EML file to disk
}
\description{
\code{read_eml()} imports metadata from an EML file into the workspace as a
\code{tibble}. \code{write_eml()} write a \code{string}, \code{tibble}, \code{list} or \code{xml_document}
to an EML file. Note that EML files always have the file extension \code{.xml}.
}
\examples{
\dontrun{
# read from a url
df <- read_eml("https://collections.ala.org.au/ws/eml/dr368")

# write to disk
write_eml(df, "example.xml")
}
}
