#' @title Install rio's \sQuote{Suggests} Dependencies
#' @description Not all suggested packages are installed by default. These packages are not installed or loaded by default in order to create a slimmer and faster package build, install, and load. Use `show_unsupported_formats()` to check all unsupported formats. `install_formats()` installs all missing \sQuote{Suggests} dependencies for rio that expand its support to the full range of support import and export formats.
#' @param \dots Additional arguments passed to [utils::install.packages()].
#' @return For `show_unsupported_formats()`, if there is any missing unsupported formats, it return TRUE invisibly; otherwise FALSE. For `install_formats()` it returns TRUE invisibly if the installation is succuessful; otherwise errors.
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

#' @rdname install_formats
#' @export
show_unsupported_formats <- function() {
    ## default_formats <- sort(unique(rio_formats$format[rio_formats$type == "import"]))
    suggested_formats <- rio_formats[rio_formats$type == "suggest",]
    suggested_formats$pkg <- vapply(strsplit(suggested_formats$import_function, "::"), FUN = `[`, FUN.VALUE = character(1), 1)
    missing_pkgs <- uninstalled_formats()
    suggested_formats$installed <- vapply(suggested_formats$pkg, function(x) x %in% missing_pkgs, logical(1), USE.NAMES = FALSE)
    unsupported_formats <- suggested_formats[suggested_formats$installed,]
    if (nrow(unsupported_formats) == 0) {
        message("All default and optional formats are supported.")
        return(invisible(FALSE))
    }
    temp_display <- unsupported_formats[,c("input", "format", "pkg")]
    colnames(temp_display)[3] <- "Suggested package"
    print(temp_display)
    message("These formats are not supported. If you need to use these formats, please either install the suggested packages individually, or install_formats() to install them all.")
    return(invisible(TRUE))
}
