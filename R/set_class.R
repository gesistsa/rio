set_class <- function(x, class = NULL) {
    if (is.null(class)) {
        return(x)
    } else if ("data.table" %in% class) {
        if (inherits(x, "data.table")) {
            return(x)
        }
        return(data.table::as.data.table(x))
    } else if ("tibble" %in% class || "tbl_df" %in% class || "tbl" %in% class) {
        if (inherits(x, "tbl")) {
            return(x)
        }
        return(tibble::as_tibble(x))
    }
    out <- structure(x, class = "data.frame")
    # add row names in case `x` wasn't already a data frame (e.g., matlab list)
    if (!length(rownames(out))) {
        rownames(out) <- as.character(seq_len(length(out[,1L,drop = TRUE])))
    }
    return(out)
}
