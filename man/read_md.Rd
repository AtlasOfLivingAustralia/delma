% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_md.R
\name{read_md}
\alias{read_md}
\title{Read markdown-formatted metadata}
\usage{
read_md(file)
}
\arguments{
\item{file}{Filename to read from. Must be either \code{.Rmd} or \code{.qmd} file.}
}
\value{
\code{read_md()} returns an object of class \code{tbl_df}, \code{tbl} and
\code{data.frame} (i.e. a \code{tibble}).
}
\description{
\code{read_md()} imports metadata from a markdown file into the workspace as a
\code{tibble}.
}
\details{
\code{\link[=read_md]{read_md()}} is unusual in that it calls \code{\link[rmarkdown:render]{rmarkdown::render()}} or
\code{\link[quarto:quarto_render]{quarto::quarto_render()}} internally to ensure code blocks and snippets
are parsed correctly. This ensures dynamic content is rendered correctly in
the resulting \code{EML} document, but makes this function considerably slower
than a standard import function. Conceptually, therefore, it is closer to a
renderer with output type \code{tibble} than a traditional \code{read_} function.

This approach has one unusual consequence; it prevents 'round-tripping' of
embedded code. That is, dynamic content in code snippets within the
metadata statement is rendered to plain text in \code{EML.} If that \code{EML} document
is later re-imported to \code{Rmd} using \code{\link[=read_eml]{read_eml()}} and \code{\link[=write_md]{write_md()}}, formerly
dynamic content will be shown as plain text.

Internally, \code{\link[=read_md]{read_md()}} calls \code{\link[lightparser:split_to_tbl]{lightparser::split_to_tbl()}}.
}
\examples{
source_file <- system.file("extdata", 
                           "bionet_metadata.Rmd",
                           package = "delma")
read_md(source_file)
}
