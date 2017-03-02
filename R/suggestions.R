#' @title Install rio's \sQuote{Suggests} Dependencies
#' @description This function installs various \sQuote{Suggests} dependencies for rio that expand its support to the full range of support import and export formats. These packages are not installed or loaded by default in order to create a slimmer and faster package build, install, and load.
#' @param \dots Additional arguments passed to \code{\link[utils]{install.packages}}.
#' @return \code{NULL}
#' @importFrom utils installed.packages install.packages
#' @export
install_formats <- function(...) {
    install.packages(suggestions[!suggestions %in% installed.packages()[ , 1, drop = TRUE]], ...)
}

suggestions <- c("csvy", "feather", "fst", "jsonlite", "openxlsx", "readODS", "readr", "rmatio", "yaml")
