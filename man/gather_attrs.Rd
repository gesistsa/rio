\name{gather_attrs}
\alias{gather_attrs}
\title{Gather attributes from data.frame variables}
\description{This function moves variable-level attributes to the data.frame level}
\usage{
    gather_attrs(x)
}
\arguments{
    \item{x}{A data.frame.}
}
\value{A data.frame.}
\details{
\code{\link{import}} attempts to standardize the return value from the various import functions to the extent possible, thus providing a uniform data structure regardless of what import package or function is used. It achieves this by storing any optional variable-related attributes at the variable level (i.e., an attribute for \code{mtcars$mpg} is stored in \code{attributes(mtcars$mpg)} rather than \code{attributes(mtcars)}). \code{gather_attrs} moves these to the data.frame-level (i.e., in \code{attributes(mtcars)}).
}
\examples{
e <- import("http://www.stata-press.com/data/r13/auto.dta")
str(e)
g <- gather_attrs(e)
str(attributes(e))
str(g)
}
\seealso{\code{\link{import}}}
