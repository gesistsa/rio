.onLoad <- function(libname, pkgname) {
    options(datatable.fread.dec.experiment=FALSE)
}

.onAttach <- function(libname, pkgname) {
    if (interactive()) {
        w <- suggestions %in% available.packages()[ , 1, drop = TRUE]
        if (any(w)) {
            msg <- "The following rio suggested packages are not installed: %s\nUse 'install_formats()' to install them"
            packageStartupMessage(sprintf(msg, paste0(sQuote(suggestions[!w]), collapse = ", ")))
        }
    }
}
