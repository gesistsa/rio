standardize_attributes <- function(dat) {
    out <- legacy_haven_meta(dat)
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
        out[[i]] <- legacy_haven_meta(out[[i]])
        if ("value.labels" %in% names(attributes(out[[i]]))) {
            attr(out[[i]], "labels") <- attr(out[[i]], "value.labels", exact = TRUE)
            attr(out[[i]], "value.labels") <- NULL
        }
        if (any(grepl("haven_labelled", class(out[[i]]), fixed = TRUE))) {
            out[[i]] <- unclass(out[[i]])
        }
        if ("var.labels" %in% names(a)) {
            attr(out[[i]], "label") <- a$var.labels[i]
        }
        if (any(grepl("$format", names(a), fixed = TRUE))) {
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

# Newer haven stores metadata in the S7 "haven_meta" attribute; convert it
# back to the attributes set by earlier versions
legacy_haven_meta <- function(x) {
    meta <- attr(x, "haven_meta", exact = TRUE)
    if (is.null(meta)) {
        return(x)
    }
    attr(x, "haven_meta") <- NULL
    if (is.data.frame(x)) {
        attr(x, "notes") <- attr(meta, "notes", exact = TRUE)
    } else {
        vendor <- sub("^haven::meta_var_", "", class(meta)[1L])
        attr(x, paste0("format.", vendor)) <- attr(meta, "format", exact = TRUE)
        display_width <- attr(meta, "display_width", exact = TRUE)
        if (!is.null(display_width) && display_width != 8L) {
            attr(x, "display_width") <- display_width
        }
    }
    x
}

restore_labelled <- function(x) {
    # restore labelled variable classes
    x[] <- lapply(x, function(v) {
        if (is.factor(v)) {
            haven::labelled(
                x = as.numeric(v),
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
