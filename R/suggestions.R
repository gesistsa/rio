#' @title Install rio's \sQuote{Suggests} Dependencies
#' @description This function installs various \sQuote{Suggests} dependencies for rio that expand its support to the full range of support import and export formats. These packages are not installed or loaded by default in order to create a slimmer and faster package build, install, and load.
#' @param \dots Additional arguments passed to \code{\link[utils]{install.packages}}.
#' @return \code{NULL}
#' @importFrom utils install.packages
#' @examples
#' \donttest{
#' if (interactive()) {
#' install_formats()
#' }
#' }
#' @export
install_formats <- function(...) {

    to_install <- uninstalled_formats()

    if (length(to_install)) {
        utils::install.packages(to_install, ...)
    }
    return(TRUE)
}

#' @importFrom utils packageName
uninstalled_formats <- function() {
    # Suggested packages (robust to changes in DESCRIPTION file)
    # Instead of flagging *new* suggestions by hand, this method only requires
    # flagging *non-import* suggestions (such as `devtools`, `knitr`, etc.).
    # This could be even more robust if the call to `install_formats()` instead
    # wrapped a call to `<devools|remotes>::install_deps(dependencies =
    # "Suggests")`, since this retains the package versioning (e.g. `xml2 (>=
    # 1.2.0)`) suggested in the `DESCRIPTION` file. However, this seems a bit
    # recursive, as `devtools` or `remotes` are often also in the `Suggests`
    # field.
    suggestions <- read.dcf(system.file("DESCRIPTION", package = utils::packageName(), mustWork = TRUE), fields = "Suggests")
    suggestions <- parse_suggestions(suggestions)
    common_suggestions <- c("bit64", "datasets", "devtools", "knitr", "magrittr", "testthat")
    suggestions <- setdiff(suggestions, common_suggestions)

    # which are not installed
    unlist(lapply(suggestions, function(x) {
        if (length(find.package(x, quiet = TRUE))) {
            NULL
        } else {
            x
        }
    }))
}

parse_suggestions <- function(suggestions) {
    suggestions <- unlist(strsplit(suggestions, split = ",|, |\n"))
    suggestions <- gsub("\\s*\\(.*\\)", "", suggestions)
    suggestions <- sort(suggestions[suggestions != ""])
    suggestions
}
