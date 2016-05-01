gather_attrs <- function(x) {
    if (!inherits(x, "data.frame")) {
        stop("'x' is not a data.frame")
    }
    dfattrs <- attributes(x)
    varattrs <- list()
    for (i in seq_along(x)) {
        varattrs[[i]] <- attributes(x[[i]])
        attributes(x[[i]]) <- NULL
        if ("levels" %in% names(varattrs[[i]])) {
           attr(x[[i]], "levels") <- varattrs[[i]][["levels"]]
        }
    }
    attrnames <- sort(unique(unlist(lapply(varattrs, names))))
    outattrs <- setNames(lapply(attrnames, function(z) {
        setNames(lapply(varattrs, `[[`, z), names(x))
    }), attrnames)
    attributes(x) <- c(dfattrs, outattrs)
    x
}
