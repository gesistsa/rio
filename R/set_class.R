set_class <- function(x, class = NULL) {
    if (is.null(class)) {
        return(x)
    }

    if ("data.table" %in% class) {
        return(.ensure_data_table(x))
    }

    if (any(c("tibble", "tbl_df", "tbl") %in% class)) {
        return(.ensure_tibble(x))
    }

    if (any(c("arrow", "arrow_table") %in% class)) {
        ## because setclass can be used without import, must check again
        .check_pkg_availability("arrow")
        return(.ensure_arrow(x))
    }
    return(.ensure_data_frame(x))
}

.ensure_arrow <- function(x) {
    if (inherits(x, "ArrowTabular")) {
        return(x)
    }
    return(arrow::arrow_table(x))
}

.ensure_data_table <- function(x) {
    if (inherits(x, "data.table")) {
        return(x)
    }
    return(data.table::as.data.table(x))
}

.ensure_tibble <- function(x) {
    if (inherits(x, "tbl")) {
        return(x)
    }
    return(tibble::as_tibble(x))
}

.ensure_data_frame <- function(x) {
    out <- structure(x, class = "data.frame")
    if (nrow(out) == 0) {
        return(out)
    }
    if (!length(rownames(out))) {
        rownames(out) <- as.character(seq_len(length(out[, 1L, drop = TRUE])))
    }
    return(out)
}
