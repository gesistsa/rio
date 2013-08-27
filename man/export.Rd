\name{export}
\alias{export}
\title{Writing data frame or matrix into a file}
\usage{
  export(x, file = "", guess = TRUE, format = NULL,
    row.names = FALSE, ...)
}
\arguments{
  \item{x}{data frame or matrix to be written into a file.}

  \item{file}{a character string naming a file.}

  \item{guess}{a logocal value ('TRUE' or 'FALSE'). If
  'TRUE', the file format will be chosen based on the file
  extension.}

  \item{format}{a character string code of file format,
  will override the 'guess' option}

  \item{row.names}{a logical value ('TRUE' or 'FALSE')
  indicating whether the row names of 'x' are to be written
  along with 'x'}

  \item{...}{additional arguments for the underlying export
  functions.}
}
\description{
  This function exports a data frame or matrix to a file
  with file format based on the file extension.
}

