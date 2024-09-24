.onAttach <- function(libname, pkgname) {
    if (interactive()) {
        w <- uninstalled_formats()
        if (length(w)) {
            msg <- "Some optional R packages were not installed and therefore some file formats are not supported. Check file support with show_supported_formats()"
            packageStartupMessage(sprintf(msg, toString(sQuote(w))))
        }
    }
}
