\name{convert}
\alias{convert}
\title{Convert from one file format to another}
\usage{convert(in_file, out_file, in_opts = list(), out_opts = list())}
\arguments{
    \item{in_file}{a character string naming an input file.}
    \item{out_file}{a character string naming an output file.}
    \item{in_opts}{a named list of options to be passed to \code{\link{import}}}
    \item{out_opts}{a named list of options to be passed to \code{\link{export}}}
}
\value{The name of the output file (invisibly).}
\description{This function constructs a data frame from a data and exports to the specified format based on the file extension.}
\examples{
# create a file to convert
export(iris, "iris.csv")

# perform conversion and open converted file
convert("iris.csv", "iris.dta")
head(import("iris.dta"))

# cleanup
unlink("iris.csv")
unlink("iris.dta")
}
