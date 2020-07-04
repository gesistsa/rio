standardize_attributes <- function(dat) {
    out <- dat
    a <- attributes(out)
    if ("variable.labels" %in% names(a)) {
        names(a)[names(a) == "variable.labels"] <- "var.labels"
        a$var.labels <- unname(a$var.labels)
    }
    # cleanup import
    attr(out, "var.labels") <- NULL      # Stata
    attr(out, "variable.labels") <- NULL # SPSS
    attr(out, "formats") <- NULL
    attr(out, "types") <- NULL
    attr(out, "label.table") <- NULL
    for (i in seq_along(out)) {
        if ("value.labels" %in% names(attributes(out[[i]]))) {
            attr(out[[i]], "labels") <- attr(out[[i]], "value.labels", exact = TRUE)
            attr(out[[i]], "value.labels") <- NULL
        }
        if (any(grepl("haven_labelled", class(out[[i]])))) {
            out[[i]] <- unclass(out[[i]])
        }
        if ("var.labels" %in% names(a)) {
            attr(out[[i]], "label") <- a$var.labels[i]
        }
        if (any(grepl("$format", names(a)))) {
            attr(out[[i]], "format") <- a[[grep("$format", names(a))[1L]]][i]
        }
        if ("types" %in% names(a)) {
            attr(out[[i]], "type") <- a$types[i]
        }
        if ("val.labels" %in% names(a) && (a$val.labels[i] != "")) {
            attr(out[[i]], "labels") <- a$label.table[[a$val.labels[i]]]
        }
    }
    out
}

restore_labelled <- function(x) {
    # restore labelled variable classes
    x[] <- lapply(x, function(v) {
        if (is.factor(v)) {
            haven::labelled(
                x = v,
                labels = stats::setNames(seq_along(levels(v)), levels(v)),
                label = attr(v, "label", exact = TRUE)
            )
        } else if (!is.null(attr(v, "labels", exact = TRUE)) || !is.null(attr(v, "label", exact = TRUE))) {
            haven::labelled(
                x = v,
                labels = attr(v, "labels", exact = TRUE),
                label = attr(v, "label", exact = TRUE)
            )
        } else {
            v
        }
    })
    x
}
