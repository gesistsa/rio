#' @title Import list of data frames
#' @description Use [import()] to import a list of data frames from a vector of file names or from a multi-object file (Excel workbook, .Rdata file, compressed directory in a zip file or tar archive, or HTML file)
#' @param file A character string containing a single file name for a multi-object file (e.g., Excel workbook, zip file, tar archive, or HTML file), or a vector of file paths for multiple files to be imported.
#' @param which If `file` is a single file path, this specifies which objects should be extracted (passed to [import()]'s `which` argument). Ignored otherwise.
#' @param rbind A logical indicating whether to pass the import list of data frames through [data.table::rbindlist()].
#' @param rbind_label If `rbind = TRUE`, a character string specifying the name of a column to add to the data frame indicating its source file.
#' @param rbind_fill If `rbind = TRUE`, a logical indicating whether to set the `fill = TRUE` (and fill missing columns with `NA`).
#' @param \dots Additional arguments passed to [import()]. Behavior may be unexpected if files are of different formats.
#' @inheritParams import
#' @inheritSection import Trust
#' @inheritSection import Which
#' @inherit import references
#' @return If `rbind=FALSE` (the default), a list of a data frames. Otherwise, that list is passed to [data.table::rbindlist()] with `fill = TRUE` and returns a data frame object of class set by the `setclass` argument; if this operation fails, the list is returned.
#' @details When file is a vector of file paths and any files are missing, those files are ignored (with warnings) and this function will not raise any error. For compressed files, the file name must also contain information about the file format of all compressed files, e.g. `files.csv.zip` for this function to work.
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
#'
#' # import and rbind all worksheets, the return value is a data frame
#' import_list(xlsx_file, rbind = TRUE)
#' @seealso [import()], [export_list()], [export()]
#' @export
import_list <- function(file, setclass = getOption("rio.import.class", "data.frame"), which, rbind = FALSE,
                        rbind_label = "_file", rbind_fill = TRUE, ...) {
    .check_file(file, single_only = FALSE)
    ## special cases
    if (length(file) == 1) {
        x <- .read_file_as_list(file = file, which = which, setclass = setclass, rbind = rbind, rbind_label = rbind_label, ...)
    } else {
        ## note the plural
        x <- .read_multiple_files_as_list(files = file, setclass = setclass, rbind = rbind, rbind_label = rbind_label, ...)
    }
    ## optionally rbind
    if (isTRUE(rbind)) {
        if (length(x) == 1) {
            x <- x[[1L]]
        } else {
            x2 <- try(data.table::rbindlist(x, fill = rbind_fill), silent = TRUE)
            if (inherits(x2, "try-error")) {
                warning("Attempt to rbindlist() the data did not succeed. List returned instead.", call. = FALSE)
                return(x)
            } else {
                x <- x2
            }
        }
        x <- set_class(x, class = setclass)
    }
    return(x)
}

.strip_exts <- function(file) {
    vapply(file, function(x) tools::file_path_sans_ext(basename(x)), character(1))
}

.read_multiple_files_as_list <- function(files, setclass, rbind, rbind_label, ...) {
    names(files) <- .strip_exts(files)
    x <- lapply(files, function(thisfile) {
        out <- try(import(thisfile, setclass = setclass, ...), silent = TRUE)
        if (inherits(out, "try-error")) {
            warning(sprintf("Import failed for %s", thisfile), call. = FALSE)
            ##out <- NULL
            return(NULL)
        } else if (isTRUE(rbind)) {
            out[[rbind_label]] <- thisfile
        }
        structure(out, filename = thisfile)
    })
    names(x) <- names(files)
    return(x)
}

.read_file_as_list <- function(file, which, setclass, rbind, rbind_label, ...) {
    if (R.utils::isUrl(file)) {
        file <- remote_to_local(file)
    }
    if (get_info(file)$format == "rdata") {
        return(.import.rio_rdata(file = file, .return_everything = TRUE, ...))
    }
    archive_format <- find_compress(file)
    if (!get_info(file)$format %in% c("html", "xlsx", "xls") && !archive_format$compress %in% c("zip", "tar", "tar.gz", "tar.bz2")) {
        which <- 1
        whichnames <- NULL
    }
    ## getting list of `whichnames`
    if (get_info(file)$format == "html") {
        .check_pkg_availability("xml2")
        tables <- xml2::xml_find_all(xml2::read_html(unclass(file)), ".//table")
        if (missing(which)) {
            which <- seq_along(tables)
        }
        whichnames <- vapply(xml2::xml_attrs(tables[which]),
            function(x) if ("class" %in% names(x)) x["class"] else "",
            FUN.VALUE = character(1)
        )
        names(which) <- whichnames
    }
    if (get_info(file)$format %in% c("xls", "xlsx")) {
        ## .check_pkg_availability("readxl")
        whichnames <- readxl::excel_sheets(path = file)
        if (missing(which)) {
            which <- seq_along(whichnames)
            names(which) <- whichnames
        } else if (is.character(which)) {
            whichnames <- which
        } else {
            whichnames <- whichnames[which]
        }
    }
    if (archive_format$compress %in% c("zip", "tar", "tar.gz", "tar.bz2")) {
        whichnames <- .list_archive(file, archive_format$compress)
        if (missing(which)) {
            which <- seq_along(whichnames)
            names(which) <- .strip_exts(whichnames)
        } else if (is.character(which)) {
            whichnames <- whichnames[whichnames %in% which]
        } else {
            names(which) <- .strip_exts(whichnames)
        }
    }
    ## reading all `whichnames`
    x <- lapply(which, function(thiswhich) {
        out <- try(import(file, setclass = setclass, which = thiswhich, ...), silent = TRUE)
        if (inherits(out, "try-error")) {
            warning(sprintf("Import failed for %s from %s", thiswhich, file))
            out <- NULL
        } else if (isTRUE(rbind) && length(which) > 1) {
            out[[rbind_label]] <- thiswhich
        }
        out
    })
    names(x) <- whichnames
    return(x)
}
