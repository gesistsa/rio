\name{export}
\alias{export}
\title{Write data.frame or matrix to a file}
\usage{
    export(x, file, format, ...)
}
\arguments{
    \item{x}{A data frame or matrix to be written into a file.}
    \item{file}{A character string naming a file. Must specify \code{file} and/or \code{format}.}
    \item{format}{An optional character string containing the file format, which can be used to override the format inferred from \code{file} or, in lieu of specifying \code{file}, a file with the symbol name of \code{x} and the specified file extension will be created. Must specify \code{file} and/or \code{format}.}
    \item{...}{Additional arguments for the underlying export functions.}
}
\value{The name of the output file as a character string (invisibly).}
\description{This function exports a data frame or matrix into a file with file format based on the file extension (or the manually specified format, if \code{format} is specified).

\code{export} supports many file formats. See the documentation for the underlying export functions for optional arguments that can be passed via \code{...}

\itemize{
    \item Tab-separated data (.tsv), using \code{\link[utils]{write.table}} with \code{row.names = FALSE}
    \item Comma-separated data (.csv), using \code{\link[utils]{write.csv}} with \code{row.names = FALSE}
    \item Fixed-width format data (.fwf), using \code{\link[utils]{write.table}} with \code{row.names = FALSE}
    \item Serialized R objects (.rds), using \code{\link[base]{saveRDS}}
    \item Saved R ojbects (.RData), using \code{\link[base]{save}}
    \item JSON (.json), using \code{\link[jsonlite]{toJSON}}
    \item Stata (.dta), using \code{\link[haven]{write_dta}}
    \item SPSS (.sav), using \code{\link[haven]{write_sav}}
    \item "XBASE" database files (.dbf), using \code{\link[foreign]{write.dbf}}
    \item Weka Attribute-Relation File Format (.arff), using \code{\link[foreign]{write.arff}}
    \item R syntax object (.R), using \code{\link[base]{dput}} (by default) or \code{\link[base]{dump}} (if \code{format = 'dump'}
    \item Excel (.xlsx), using \code{\link[openxlsx]{write.xlsx}}
    \item Clipboard export, using \code{\link[utils]{write.table}} with \code{row.names = FALSE}
}

}
\examples{
# specify `file`
export(iris, "iris.csv")

# specify only `format`
"iris.dta" %in% dir()
export(iris, format = "stata")
"iris.dta" %in% dir()

# cleanup
unlink("iris.csv")
unlink("iris.dta")
}
