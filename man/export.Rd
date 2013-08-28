\name{export}
\alias{export}
\title{Writing data frame or matrix into a file}
\usage{
  export(x, file = "", format = NULL, row.names = FALSE,
    header = TRUE, ...)
}
\arguments{
  \item{x}{data frame or matrix to be written into a file.}

  \item{file}{a character string naming a file.}

  \item{format}{a character string code of file format. The
  following file formats are supported: txt, rds, csv and
  dta.}

  \item{row.names}{a logical value ('TRUE' or 'FALSE')
  indicating whether the row names of 'x' are to be written
  along with 'x'}

  \item{header}{a logical value indicating whether the file
  contains the names of the variables as its first line.}

  \item{...}{additional arguments for the underlying export
  functions.}
}
\description{
  This function exports a data frame or matrix into a data
  file with file format based on the file extension.
}
\examples{
export(iris, "iris.csv")
}

