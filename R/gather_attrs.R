#' @rdname gather_attrs
#' @title Gather attributes from data frame variables
#' @description \code{gather_attrs} moves variable-level attributes to the data frame level and \code{spread_attrs} reverses that operation.
#' @details \code{\link{import}} attempts to standardize the return value from the various import functions to the extent possible, thus providing a uniform data structure regardless of what import package or function is used. It achieves this by storing any optional variable-related attributes at the variable level (i.e., an attribute for \code{mtcars$mpg} is stored in \code{attributes(mtcars$mpg)} rather than \code{attributes(mtcars)}). \code{gather_attrs} moves these to the data frame level (i.e., in \code{attributes(mtcars)}). \code{spread_attrs} moves attributes back to the variable level.
#' @param x A data frame.
#' @return \code{x}, with variable-level attributes stored at the data frame level.
#' @examples
#' e <- import("http://www.stata-press.com/data/r13/auto.dta")
#' str(e)
#' g <- gather_attrs(e)
#' str(attributes(e))
#' str(g)
#' @seealso \code{\link{import}}, \code{\link{characterize}}
#' @importFrom stats setNames
#' @export
gather_attrs <- function(x) {
    if (!inherits(x, "data.frame")) {
        stop("'x' is not a data.frame")
    }
    dfattrs <- attributes(x)
    if ("label" %in% names(dfattrs)) {
        names(dfattrs)[names(dfattrs) == "label"] <- "title"
    }
    varattrs <- rep(list(list()), length(x))
    for (i in seq_along(x)) {
        a <- attributes(x[[i]])
        varattrs[[i]] <- a[!names(a) %in% c("levels", "class")]
        attr(x[[i]], "label") <- NULL
        if (any(grepl("labelled", class(x[[i]])))) {
            x[[i]] <- haven::zap_labels(x[[i]])
        }
        f <- grep("^format", names(attributes(x$foreign)), value = TRUE)
        if (length(f)) {
            attr(x[[i]], f) <- NULL
        }
        rm(f)
    }
    if (any(sapply(varattrs, length))) {
        attrnames <- sort(unique(unlist(lapply(varattrs, names))))
        outattrs <- stats::setNames(lapply(attrnames, function(z) {
            stats::setNames(lapply(varattrs, `[[`, z), names(x))
        }), attrnames)
        attributes(x) <- c(dfattrs, outattrs)
    }
    x
}

#' @rdname gather_attrs
#' @export
spread_attrs <- function(x) {
    if (!inherits(x, "data.frame")) {
        stop("'x' is not a data.frame")
    }
    dfattrs <- attributes(x)
    d_level_attrs <- names(dfattrs) %in% c("row.names", "class", "names", "notes", "title")
    varattrs <- dfattrs[!d_level_attrs]
    for (i in seq_along(x)) {
        a <- attributes(x[[i]])
        attributes(x[[i]]) <- c(a, lapply(varattrs, `[[`, i))
    }
    if ("title" %in% names(dfattrs)) {
        names(dfattrs)[names(dfattrs) == "title"] <- "label"
    }
    attributes(x) <- dfattrs[d_level_attrs]
    x
}
