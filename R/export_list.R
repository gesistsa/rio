#' @title Export list of data frames to files
#' @description Use [export()] to export a list of data frames to a vector of file names or a filename pattern.
#' @param x A list of data frames to be written to files.
#' @param file A character vector string containing a single file name with a `\%s` wildcard placeholder, or a vector of file paths for multiple files to be imported. If `x` elements are named, these will be used in place of `\%s`, otherwise numbers will be used; all elements must be named for names to be used.
#' @param archive character. Either empty string (default) to save files in current
#' directory, a path to a (new) directory, or a .zip/.tar file to compress all
#' files into an archive.
#' @param \dots Additional arguments passed to [export()].
#' @return The name(s) of the output file(s) as a character vector (invisibly).
#' @details [export()] can export a list of data frames to a single multi-dataset file (e.g., an Rdata or Excel .xlsx file). Use `export_list` to export such a list to *multiple* files.
#' @examples
#' ## For demo, a temp. file path is created with the file extension .xlsx
#' xlsx_file <- tempfile(fileext = ".xlsx")
#' export(
#'     list(
#'         mtcars1 = mtcars[1:10, ],
#'         mtcars2 = mtcars[11:20, ],
#'         mtcars3 = mtcars[21:32, ]
#'     ),
#'     xlsx_file
#' )
#'
#' # import a single file from multi-object workbook
#' import(xlsx_file, sheet = "mtcars1")
#' # import all worksheets, the return value is a list
#' import_list(xlsx_file)

#' library('datasets')
#' export(list(mtcars1 = mtcars[1:10,],
#'             mtcars2 = mtcars[11:20,],
#'             mtcars3 = mtcars[21:32,]),
#'     xlsx_file <- tempfile(fileext = ".xlsx")
#' )
#'
#' # import all worksheets
#' list_of_dfs <- import_list(xlsx_file)
#'
#' # re-export as separate named files
#'
#' ## export_list(list_of_dfs, file = c("file1.csv", "file2.csv", "file3.csv"))
#'
#' # re-export as separate files using a name pattern; using the names in the list
#' ## This will be written as "mtcars1.csv", "mtcars2.csv", "mtcars3.csv"
#'
#' ## export_list(list_of_dfs, file = "%s.csv")
#' @seealso [import()], [import_list()], [export()]
#' @export
export_list <- function(x, file, archive = "", ...) {
    .check_file(file, single_only = FALSE)
    archive_format <- find_compress(archive)
    supported_archive_formats <- c("zip", "tar", "tar.gz", "tar.bz2")
    if (!is.na(archive_format$compress) && !archive_format$compress %in% supported_archive_formats) {
        stop("'archive' is specified but format is not supported. Only zip and tar formats are supported.", call. = FALSE)
    }
    if (inherits(x, "data.frame")) {
        stop("'x' must be a list. Perhaps you want export()?", call. = FALSE)
    }
    .check_tar_support(archive_format$compress, getRversion())

    outfiles <- .create_outfiles(file, x)

    if (is.na(archive_format$compress) && archive_format$file != "") {
        outfiles <- file.path(archive_format$file, outfiles)
    }
    outfiles_normalized <- normalizePath(outfiles, mustWork = FALSE)

    out <- list()
    for (f in seq_along(x)) {
        out[[f]] <- try(export(x[[f]], file = outfiles_normalized[f], ...), silent = TRUE)
        if (inherits(out[[f]], "try-error")) {
            warning(sprintf("Export failed for element %d, filename: %s", f, outfiles[f]))
        }
    }
    if (!is.na(archive_format$compress)) {
        .create_directory_if_not_exists(archive)
        compress_out(archive, outfiles_normalized, type = archive_format$compress)
        unlink(outfiles_normalized)
        return(invisible(archive))
    }
    return(invisible(outfiles))
}
