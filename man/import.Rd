\name{import}
\alias{import}
\title{Reading data frame or matrix from a file}
\usage{
  import(file = "", format = NULL, header = TRUE, ...)
}
\arguments{
  \item{file}{a character string naming a file.}

  \item{format}{a character string code of file format. The
  following file formats are supported: txt, rds, csv, dta,
  sav, mtp and rec.}

  \item{header}{a logical value indicating whether the file
  contains the names of the variables as its first line.}

  \item{...}{Additional arguments for the underlying import
  functions.}
}
\description{
  This function imports a data frame or matrix from a data
  file with the file format based on the file extension.
}
\examples{
#x <- import("iris.dta")
}

