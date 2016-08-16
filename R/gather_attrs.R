#' @title Gather attributes from data.frame variables
#' @description This function moves variable-level attributes to the data.frame level
#' @details \code{\link{import}} attempts to standardize the return value from the various import functions to the extent possible, thus providing a uniform data structure regardless of what import package or function is used. It achieves this by storing any optional variable-related attributes at the variable level (i.e., an attribute for \code{mtcars$mpg} is stored in \code{attributes(mtcars$mpg)} rather than \code{attributes(mtcars)}). \code{gather_attrs} moves these to the data.frame-level (i.e., in \code{attributes(mtcars)}).
#' @param x A data.frame.
#' @return \code{x}, with variable-level attributes stored at the data.frame level.
#' @examples
#' e <- import("http://www.stata-press.com/data/r13/auto.dta")
#' str(e)
#' g <- gather_attrs(e)
#' str(attributes(e))
#' str(g)
#' @seealso \code{\link{import}}
#' @export
gather_attrs <- function(x) {
    if (!inherits(x, "data.frame")) {
        stop("'x' is not a data.frame")
    }
    dfattrs <- attributes(x)
    varattrs <- rep(list(list()), length(x))
    for (i in seq_along(x)) {
        a <- attributes(x[[i]])
        varattrs[[i]] <- a[!names(a) %in% c("levels", "class")]
        attributes(x[[i]]) <- a[names(a) %in% c("levels", "class")]
    }
    if (any(sapply(varattrs, length))) {
        attrnames <- sort(unique(unlist(lapply(varattrs, names))))
        outattrs <- setNames(lapply(attrnames, function(z) {
            setNames(lapply(varattrs, `[[`, z), names(x))
        }), attrnames)
        attributes(x) <- c(dfattrs, outattrs)
    }
    x
}
