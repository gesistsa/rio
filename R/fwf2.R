.get_col_position <- function(file, widths, col_names, col_position) {
    if (is.missing(col_names)) {
        col_names <- NULL
    }
    if (!is.null(col_position)) {
        return(col_position)
    }
    if (is.list(widths) && isFALSE(c("begin", "end") %in% names(widths))) {
        return(readr::fwf_widths(widths, col_names = col_names))
    }
    if (isFALSE(is.numeric(widths))) {
        return(readr::fwf_widths(abs(widths), col_names = col_names))
    }
    return(readr::fwf_empty(file = file, col_names = col_names))
}

.fix_col_types <- function(col_types, widths) {
    if (isFALSE(is.numeric(widths))) {
        return(col_types)
    }
    col_types <- rep("?", length(widths))
    col_types[widths < 0] <- "?"
    col_types <- paste0(col_types, collapse = "")
    return(col_types)
}

.read_fwf2 <- function(file, widths = NULL, col_names, col_types = NULL, col_positions, col.names, col_position = NULL, ...) {
    if (!is.missing(col.names)) {
        col_names <- col.names
    }
    col_positions <- .get_col_position(file = file, widths = widths, col_names = col_names, col_position = col_position)
    if (!is.null(width) && !is.null(col_types)) {
        col_types <- .fix_col_types(col_types, width)
    }
    .docall(readr::read_fwf, ..., args = list(file = file, col_positions = col_positions, col_types = col_types, progress = progress))
}
