\name{import}
\alias{import}
\title{Read data.frame or matrix from a file}
\usage{
    import(file, format, ...)
}
\arguments{
    \item{file}{A character string naming a file, URL, or single-file .zip or .tar archive.}
    \item{format}{An optional character string code of file format, which can be used to override the format inferred from \code{file}. Shortcuts include: \dQuote{,} (for comma-separated values), \dQuote{;} (for semicolon-separated values), and \dQuote{|} (for pipe-separated values).}
    \item{...}{Additional arguments for the underlying import functions.}
}
\value{An R data.frame.}
\description{This function imports a data frame or matrix from a data file with the file format based on the file extension (or the manually specified format, if \code{format} is specified).

\code{import} supports the following file formats:

\itemize{
    \item Tab-separated data (.tsv), using \code{\link[utils]{read.table}} with \code{row.names = FALSE} and \code{stringsAsFactors = FALSE}
    \item Comma-separated data (.csv), using \code{\link[utils]{read.csv}} with \code{row.names = FALSE} and \code{stringsAsFactors = FALSE}
    \item Pipe-separated data (.psv), using \code{\link[utils]{read.table}} with \code{sep = '|'}, \code{row.names = FALSE}, and \code{stringsAsFactors = FALSE}
    \item Fixed-width format data (.fwf), using \code{\link[utils]{read.fwf}} (which requires a \code{widths} argument and by default in rio has \code{stringsAsFactors = FALSE}
    \item Serialized R objects (.rds), using \code{\link[base]{readRDS}}
    \item Saved R objects (.RData), using \code{\link[base]{load}} for single-object .Rdata files
    \item JSON (.json), using \code{\link[jsonlite]{fromJSON}}
    \item Stata (.dta), using \code{\link[haven]{read_dta}}
    \item SPSS and SPSS portable (.sav and .por), using \code{\link[haven]{read_sav}} and \code{\link[haven]{read_por}}
    \item "XBASE" database files (.dbf), using \code{\link[foreign]{read.dbf}}
    \item Weka Attribute-Relation File Format (.arff), using \code{\link[foreign]{read.arff}}
    \item R syntax object (.R), using \code{\link[base]{dget}}
    \item Excel (.xlsx), using \code{\link[openxlsx]{read.xlsx}}
    \item SAS (.sas7bdat) and SAS XPORT (.xpt), using \code{\link[haven]{read_sas}} and \code{\link[foreign]{read.xport}}
    \item Minitab (.mtp), using \code{\link[foreign]{read.mtp}}
    \item Epiinfo (.rec), using \code{\link[foreign]{read.epiinfo}}
    \item Systat (.syd), using \code{\link[foreign]{read.systat}}
    \item Data Interchange Format (.dif), using \code{\link[utils]{read.DIF}}
    \item Fortran data (no recognized extension), using \code{\link[utils]{read.fortran}}
}
}
\note{For csv and txt files with row names exported from \code{\link{export}}, it may be helpful to specify \code{row.names} as the column of the table which contain row names. See example below.}
\examples{

# rownames in exported file
export(iris, "myIris.csv", row.names = TRUE)
iris2 <- import("myIris.csv") # with the additional spurious column
head(iris2)
iris3 <- import("myIris.csv", row.names = 1)
head(iris3)

identical(iris3, iris3)
}
