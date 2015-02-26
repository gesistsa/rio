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
\description{This function constructs a data frame from a data file using code{\link{import}} and uses \code{\link{export}} to write the data to disk in the format indicated by the file extension.}
\examples{
# create a file to convert
export(iris, "iris.csv")

# perform conversion and open converted file
convert("iris.csv", "iris.dta")
head(import("iris.dta"))

# correct an erroneous file format
export(iris, "iris.csv", format = "tsv")
convert("iris.csv", "iris.csv", in_opts = list(format = "tsv"))

# cleanup
unlink("iris.csv")
unlink("iris.dta")
}
