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

    return(.ensure_data_frame(x))
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
    if (!length(rownames(out))) {
        rownames(out) <- as.character(seq_len(length(out[, 1L, drop = TRUE])))
    }
    return(out)
}
