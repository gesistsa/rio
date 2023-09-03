#' @importFrom utils read.table
read.fwf2 <- function (file, widths, header = FALSE, sep = "\t", skip = 0, n = -1, quote = "", stringsAsFactors = FALSE, ...) {
    doone <- function(x) {
        x <- substring(x, first, last)
        x[!nzchar(x)] <- NA_character_
        paste0(x, collapse = sep)
    }
    if (is.list(widths)) {
        recordlength <- length(widths)
        widths <- do.call("c", widths)
    } else {
        recordlength <- 1L
    }
    drop <- (widths < 0L)
    widths <- abs(widths)
    if (is.character(file)) {
        file <- file(file, "rt")
        on.exit(close(file), add = TRUE)
    } else if (!isOpen(file)) {
        open(file, "rt")
        on.exit(close(file), add = TRUE)
    }
    if (skip)
        readLines(file, n = skip)
    if (header) {
        headerline <- readLines(file, n = 1L)
        text[1] <- headerline
    }
    raw <- readLines(file, n = n)
    nread <- length(raw)
    if (recordlength > 1L && nread%%recordlength) {
        raw <- raw[1L:(nread - nread%%recordlength)]
        warning(sprintf(ngettext(nread%%recordlength, "last record incomplete, %d line discarded",
            "last record incomplete, %d lines discarded"),
            nread%%recordlength), domain = NA)
    }
    if (recordlength > 1L) {
        raw <- matrix(raw, nrow = recordlength)
        raw <- apply(raw, 2L, paste, collapse = "")
    }
    st <- c(1L, 1L + cumsum(widths))
    first <- st[-length(st)][!drop]
    last <- cumsum(widths)[!drop]
    if(header) {
        text <- c(headerline, vapply(raw, doone, character(1)))
    } else {
        text <- vapply(raw, doone, character(1))
    }
    read.table(text = text, header = header, sep = sep, quote = quote, stringsAsFactors = stringsAsFactors, ...)
}
