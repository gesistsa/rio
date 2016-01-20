cleanup_haven <- function(x) {
    xinfo <- list(var.labels = sapply(x, attr, which = "label", exact = TRUE),
                  label.table = sapply(x, attr, which = "labels", exact = TRUE))
    discrete <- sapply(x, function(y) length(unique(attr(y, "labels"))) >= length(stats::na.omit(unique(y))))
    x[discrete] <- lapply(x[discrete], as_factor)
    x[sapply(x, is.numeric)] <- lapply(x[sapply(x, is.numeric)], function(y) {
        attr(y, "labels") <- NULL
        return(unclass(y))
    })
    x[] <- lapply(x, function(y) {
        attr(y, "label") <- NULL
        return(y)
    })
    for (a in names(xinfo)) {
        attr(x, a) <- xinfo[[a]]
    }
    return(x)
}
