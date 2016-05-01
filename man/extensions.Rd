\name{extensions}
\alias{extensions}
\alias{.import}
\alias{.export}
\title{rio Extensions}
\description{Writing Import/Export Extensions for rio}
\usage{
    .import(file, ...)
    .export(file, x, ...)
}
\arguments{
    \item{file}{A character string naming a file.}
    \item{x}{A data frame or matrix to be written into a file.}
    \item{...}{Additional arguments passed to methods.}
}
\value{For \code{.import}, an R data.frame. For \code{.export}, \code{file}, invisibly.}
\details{
rio implements format-specific S3 methods for each type of file that can be imported from or exported to. This happens via internal S3 generics, \code{.import} and \code{.export}. It is possible to write new methods like with any S3 generic (e.g., \code{print}).

As an example, \code{.import.rio_csv} imports from a comma-separated values file. If you want to produce a method for a new filetype with extension \dQuote{myfile}, you simply have to create a function called \code{.import.rio_myfile} that implements a format-specific importing routine and returns a data.frame. rio will automatically recognize new S3 methods, so that you can then import your file using: \code{import("file.myfile")}.

As general guidance, if an import method creates many attributes, these attributes should be stored --- to the extent possible --- in variable-level attributes fields. These can be \dQuote{gathered} to the data.frame level by the user via \code{\link{gather_attrs}}.
}
\seealso{\code{\link{import}}, \code{\link{export}}}
