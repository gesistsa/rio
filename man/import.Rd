\name{import}
\alias{import}
\title{Reading data frame or matrix from a file}
\usage{
  import(file = "", guess = TRUE, format = NULL, ...)
}
\arguments{
  \item{file}{a character string naming a file.}

  \item{guess}{a logocal value ('TRUE' or 'FALSE'). If
  'TRUE', the file format will be chosen based on the file
  extension.}

  \item{format}{a character string code of file format,
  will override the 'guess' option}

  \item{...}{Additional arguments for the underlying export
  functions.}
}
\description{
  This function imports a data frame or matrix from a file
  with the file format based on the file extension.
}

