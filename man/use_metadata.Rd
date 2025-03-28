% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/use_metadata.R
\name{use_metadata}
\alias{use_metadata}
\title{Write an example metadata statement to disk}
\usage{
use_metadata(file = NULL, overwrite = FALSE, quiet = FALSE)
}
\arguments{
\item{file}{(string) A name for the resulting file, with either \code{.Rmd} or
\code{.Qmd} as a suffix. If \code{NULL} will default to \code{metadata.md}.}

\item{overwrite}{(logical) Should any existing file be overwritten? Defaults
to \code{FALSE}.}

\item{quiet}{(logical) Should messages be suppressed? Defaults to \code{FALSE}.}
}
\value{
Doesn't return anything to the workspace; called for the side-effect
of placing a metadata statement in the working directory.
}
\description{
This function places a metadata template at the address specified by \code{"file"},
defaulting to \code{"metadata.Rmd"} in the working directory. The template is
built in such a way that standard rendering with \code{rmarkdown} or Quarto to
HTML or PDF will function; but also that it renders to valid EML using
\code{\link[=render_metadata]{render_metadata()}}.
}
\examples{
\dontrun{
use_metadata("example.Rmd") 
}
}
