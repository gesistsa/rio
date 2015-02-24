\name{import}
\alias{import}
\title{Reading data frame or matrix from a file}
\usage{
    import(file = "", format = NULL, header = TRUE, ...)
}
\arguments{
    \item{file}{a character string naming a file.}
    \item{format}{a character string code of file format. The following file formats are supported: txt, tsv, csv, rds, Rdata, dta, sav, por, mtp, json, dif, rec, dbf, sas7bdat, syd, xlsx, arff, xpt, and fwf (fixed-width format; requires a \code{widths} argument).}
    \item{header}{a logical value indicating whether the file contains the names of the variables as its first line.}
    \item{...}{Additional arguments for the underlying import functions.}
}
\value{An R dataframe.}
\description{This function imports a data frame or matrix from a data file with the file format based on the file extension.}
\note{For csv and txt files with row names exported from export(), additional ... argument of row.names might be useful to specify the column of the table which contain row names. See example below.}
\examples{
#x <- import("iris.dta")
myIris <- datasets::iris
export(myIris, "myIris.csv", row.names=TRUE)
myIris2 <- import("myIris.csv") ### with the additional spurious column
head(myIris2)
myIris3 <- import("myIris.csv", row.names=1)
head(myIris3)
}
