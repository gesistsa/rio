.onAttach <- function(libname, pkgname) {
    if (interactive()) {
        w <- uninstalled_formats()
        if (length(w)) {
            msg <- "The following rio suggested packages are not installed: %s\nUse 'install_formats()' to install them"
            packageStartupMessage(sprintf(msg, paste0(sQuote(w), collapse = ", ")))
        }
    }
}
