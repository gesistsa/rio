\name{import}
\alias{import}
\title{Read data.frame or matrix from a file}
\usage{
    import(file, format, header = TRUE, ...)
}
\arguments{
    \item{file}{A character string naming a file. Must specify \code{file}.}
    \item{format}{An optional character string code of file format, which can be used to override the format inferred from \code{file}.}
    \item{header}{A logical value indicating whether the file contains the names of the variables as its first line.}
    \item{...}{Additional arguments for the underlying import functions.}
}
\value{An R dataframe.}
\description{This function imports a data frame or matrix from a data file with the file format based on the file extension.

The following file formats are supported: txt, tsv, csv, rds, Rdata, dta, sav, por, mtp, json, dif, rec, dbf, sas7bdat, syd, xlsx, arff, xpt, and fwf (fixed-width format; requires a \code{widths} argument).
}
\note{For csv and txt files with row names exported from \code{export}, it may be helpful to specify \code{row.names} as the column of the table which contain row names. See example below.}
\examples{
export(iris, "myIris.csv", row.names=TRUE)
iris2 <- import("myIris.csv") # with the additional spurious column
head(iris2)
iris3 <- import("myIris.csv", row.names=1)
head(iris3)

identical(iris3, iris3)
}
