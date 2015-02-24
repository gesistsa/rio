\name{export}
\alias{export}
\title{Write data.frame or matrix to a file}
\usage{
    export(x, file = "", format = NULL, row.names = FALSE, header = TRUE, ...)
}
\arguments{
    \item{x}{A data frame or matrix to be written into a file.}
    \item{file}{A character string naming a file. Must specify \code{file} and/or \code{format}.}
    \item{format}{An optional character string containing the file format, which can be used to override the format inferred from \code{file} or, in lieu of specifying \code{file}, a file with the symbol name of \code{x} and the specified file extension will be created. Must specify \code{file} and/or \code{format}.}
    \item{row.names}{A logical value indicating whether the row names of \code{x} should be written along with \code{x}.}
    \item{header}{A logical value indicating whether the file contains the names of the variables as its first line.}
    \item{...}{Additional arguments for the underlying export functions.}
}
\value{The name of the output file as a character string (invisibly).}
\description{This function exports a data frame or matrix into a file with file format based on the file extension (or the manually specified format).

The following file formats are supported: txt, csv, tsv, rds, Rdata, json, dbf, sav, dta, xlsx, and arff.
}
\examples{
export(iris, "iris.csv")
}
