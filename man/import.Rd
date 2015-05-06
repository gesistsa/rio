\name{import}
\alias{import}
\title{Read data.frame or matrix from a file}
\usage{
    import(file, format, setclass, ...)
}
\arguments{
    \item{file}{A character string naming a file, URL, or single-file .zip or .tar archive.}
    \item{format}{An optional character string code of file format, which can be used to override the format inferred from \code{file}. Shortcuts include: \dQuote{,} (for comma-separated values), \dQuote{;} (for semicolon-separated values), and \dQuote{|} (for pipe-separated values).}
    \item{setclass}{An optional character vector specifying one or more classes to set on the import. By default, all the return object is always a \dQuote{data.frame}. Reasonable values for this might be \dQuote{tbl_df} (if using dplyr) or \dQuote{data.table} (if using data.table). Warnings will be produced if a class is used from a package that is not loaded and/or available.}
    \item{...}{Additional arguments for the underlying import functions.}
}
\value{An R data.frame. If \code{setclass} is used, this data.frame may have additional class attribute values.}
\description{This function imports a data frame or matrix from a data file with the file format based on the file extension (or the manually specified format, if \code{format} is specified).

\code{import} supports the following file formats:

\itemize{
    \item Tab-separated data (.tsv), using \code{\link[utils]{read.table}} with \code{row.names = FALSE} and \code{stringsAsFactors = FALSE} (or, if \code{fread = TRUE}, \code{\link[data.table]{fread}})
    \item Comma-separated data (.csv), using \code{\link[utils]{read.csv}} with \code{row.names = FALSE} and \code{stringsAsFactors = FALSE} (or, if \code{fread = TRUE}, \code{\link[data.table]{fread}})
    \item Pipe-separated data (.psv), using \code{\link[utils]{read.table}} with \code{sep = '|'}, \code{row.names = FALSE}, and \code{stringsAsFactors = FALSE} (or, if \code{fread = TRUE}, \code{\link[data.table]{fread}})
    \item Fixed-width format data (.fwf), using a faster version of \code{\link[utils]{read.fwf}} that requires a \code{widths} argument and by default in rio has \code{stringsAsFactors = FALSE}
    \item Serialized R objects (.rds), using \code{\link[base]{readRDS}}
    \item Saved R objects (.RData), using \code{\link[base]{load}} for single-object .Rdata files
    \item JSON (.json), using \code{\link[jsonlite]{fromJSON}}
    \item Stata (.dta), using \code{\link[haven]{read_dta}}
    \item SPSS and SPSS portable (.sav and .por), using \code{\link[haven]{read_sav}} and \code{\link[haven]{read_por}}
    \item "XBASE" database files (.dbf), using \code{\link[foreign]{read.dbf}}
    \item Weka Attribute-Relation File Format (.arff), using \code{\link[foreign]{read.arff}}
    \item R syntax object (.R), using \code{\link[base]{dget}}
    \item Excel (.xls and .xlsx), using \code{\link[readxl]{read_excel}}
    \item SAS (.sas7bdat) and SAS XPORT (.xpt), using \code{\link[haven]{read_sas}} and \code{\link[foreign]{read.xport}}
    \item Minitab (.mtp), using \code{\link[foreign]{read.mtp}}
    \item Epiinfo (.rec), using \code{\link[foreign]{read.epiinfo}}
    \item Systat (.syd), using \code{\link[foreign]{read.systat}}
    \item Data Interchange Format (.dif), using \code{\link[utils]{read.DIF}}
    \item OpenDocument Spreadsheet (.ods), using \code{\link[readODS]{read.ods}}
    \item Shallow XML documents (.xml), using \code{\link[XML]{xmlToDataFrame}}. Note: optional arguments not recognized by \code{xmlToDataFrame} are passed to \code{\link[XML]{xmlParse}}.
    \item Clipboard import (on Windows and Mac OS), using \code{\link[utils]{read.table}} with \code{row.names = FALSE}
    \item Fortran data (no recognized extension), using \code{\link[utils]{read.fortran}}
}
}
\note{For csv and txt files with row names exported from \code{\link{export}}, it may be helpful to specify \code{row.names} as the column of the table which contain row names. See example below.}
\examples{
# create CSV to import
export(iris, "iris1.csv")

# specify `format` to override default format
export(iris, "iris.tsv", format = "csv")
stopifnot(identical(import("iris1.csv"), import("iris.tsv", format = "csv")))

# import CSV as a `data.table`
stopifnot(inherits(import("iris1.csv", setclass = "data.table"), "data.table"))
stopifnot(inherits(import("iris1.csv", setclass = "data.table"), "data.table"))

# pass arguments to underlying import function
iris1 <- import("iris1.csv")
identical(names(iris), names(iris1))

export(iris, "iris2.csv", col.names = FALSE)
iris2 <- import("iris2.csv")
identical(names(iris), names(iris2))

# set class for the response data.frame as "tbl_df" (from dplyr)
stopifnot(inherits(import("iris1.csv", setclass = "tbl_df"), "tbl_df"))

# cleanup
unlink("iris.tsv")
unlink("iris1.csv")
unlink("iris2.csv")
}
