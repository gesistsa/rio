#' @title Export list of data frames to files
#' @description Use \code{\link{export}} to export a list of data frames to a vector of file names or a filename pattern.
#' @param x A list of data frames to be written to files.
#' @param file A character vector string containing a single file name with a \code{\%s} wildcard placeholder, or a vector of file paths for multiple files to be imported. If \code{x} elements are named, these will be used in place of \code{\%s}, otherwise numbers will be used; all elements must be named for names to be used.
#' @param \dots Additional arguments passed to \code{\link{export}}.
#' @return The name(s) of the output file(s) as a character vector (invisibly).
#' @details \code{\link{export}} can export a list of data frames to a single multi-dataset file (e.g., an Rdata or Excel .xlsx file). Use \code{export_list} to export such a list to \emph{multiple} files.
#' @examples
#' library('datasets')
#' export(list(mtcars1 = mtcars[1:10,], 
#'             mtcars2 = mtcars[11:20,],
#'             mtcars3 = mtcars[21:32,]),
#'     xlsx_file <- tempfile(fileext = ".xlsx")
#' )
#' 
#' # import all worksheets
#' mylist <- import_list(xlsx_file)
#' 
#' # re-export as separate named files
#' csv_files1 <- sapply(1:3, function(x) tempfile(fileext = paste0("-", x, ".csv")))
#' export_list(mylist, file = csv_files1)
#' 
#' # re-export as separate files using a name pattern
#' export_list(mylist, file = csv_files2 <- tempfile(fileext = "%s.csv"))
#' 
#' # cleanup
#' unlink(xlsx_file)
#' unlink(csv_files1)
#' unlink(csv_files2)
#' 
#' @seealso \code{\link{import}}, \code{\link{import_list}}, \code{\link{export}}
#' @export
export_list <- 
function(
    x,
    file, 
    ...
) {
    if (inherits(x, "data.frame")) {
        stop("'x' must be a list. Perhaps you want export()?")
    }

    if (is.null(file)) {
        stop("'file' must be a character vector")
    } else if (length(file) == 1L) {
        if (!grepl("%s", file, fixed = TRUE)) {
            stop("'file' must have a %s placehold")
        }
        if (is.null(names(x))) {
            outfiles <- sprintf(file, seq_along(x))
        } else {
            if (any(nchar(names(x))) == 0) {
                stop("All elements of 'x' must be named or all must be unnamed")
            }
            if (anyDuplicated(names(x))) {
                stop("Names of elements in 'x' are not unique")
            }
            outfiles <- sprintf(file, names(x))
        }
    } else {
        if (length(x) != length(file)) {
            stop("'file' must be same length as 'x', or a single pattern with a %s placeholder")
        }
        if (anyDuplicated(file)) {
            stop("File names are not unique")
        }
        outfiles <- file
    }

    out <- list()
    for (f in seq_along(x)) {
        out[[f]] <- try(export(x[[f]], file = outfiles[f], ...), silent = TRUE)
        if (inherits(out[[f]], "try-error")) {
            warning(sprintf("Export failed for element %d, filename: %s", f, outfiles[f]))
        }
    }

    invisible(outfiles)
}
