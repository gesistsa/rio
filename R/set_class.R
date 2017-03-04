set_class <- function(x, class = NULL) {
    if (is.null(class)) {
        return(structure(x, class = "data.frame"))
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
    return(structure(x, class = "data.frame"))
}
