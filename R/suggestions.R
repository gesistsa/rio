#' @title Install rio's \sQuote{Suggests} Dependencies
#' @description This function installs various \sQuote{Suggests} dependencies for rio that expand its support to the full range of support import and export formats. These packages are not installed or loaded by default in order to create a slimmer and faster package build, install, and load.
#' @param \dots Additional arguments passed to [utils::install.packages()].
#' @return `NULL`
#' @examples
#' \donttest{
#' if (interactive()) {
#'     install_formats()
#' }
#' }
#' @export
install_formats <- function(...) {
    to_install <- uninstalled_formats()
    utils::install.packages(to_install, ...)
    invisible(TRUE)
}

uninstalled_formats <- function() {
    suggested_packages <- attr(rio_formats, "suggested_packages")
    ## which are not installed
    suggested_packages[!R.utils::isPackageInstalled(suggested_packages)]
}
