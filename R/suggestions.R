#' @title Install rio's \sQuote{Suggests} Dependencies
#' @description This function installs various \sQuote{Suggests} dependencies for rio that expand its support to the full range of support import and export formats. These packages are not installed or loaded by default in order to create a slimmer and faster package build, install, and load.
#' @param \dots Additional arguments passed to \code{\link[utils]{install.packages}}.
#' @return \code{NULL}
#' @importFrom utils installed.packages install.packages
#' @export
install_formats <- function(...) {
    
    to_install <- uninstalled_formats()
    
    if (length(to_install)) {
        install.packages(to_install, ...)
    }
}

uninstalled_formats <- function() {
    # suggested packages
    suggestions <- c("clipr", "csvy", "feather", "fst", "jsonlite", "readODS", "readr", "rmatio", "xml2", "yaml")
    
    # which are not installed
    unlist(lapply(suggestions, function(x) {
        if (length(find.package(x, quiet = TRUE))) {
            NULL
        } else {
            x
        }
    }))
}
