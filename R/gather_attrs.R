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
