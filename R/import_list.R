#' @title Import list of data frames
#' @description Use \code{\link{import}} to import a list of data frames from a vector of file names or from a multi-object file (Excel workbook, .Rdata file, zip directory, or HTML file)
#' @param file A character string containing a single file name for a multi-object file (e.g., Excel workbook, zip directory, or HTML file), or a vector of file paths for multiple files to be imported.
#' @template setclass
#' @param which If \code{file} is a single file path, this specifies which objects should be extracted (passed to \code{\link{import}}'s \code{which} argument). Ignored otherwise.
#' @param rbind A logical indicating whether to pass the import list of data frames through \code{\link[data.table]{rbindlist}}.
#' @param rbind_label If \code{rbind = TRUE}, a character string specifying the name of a column to add to the data frame indicating its source file.
#' @param rbind_fill If \code{rbind = TRUE}, a logical indicating whether to set the \code{fill = TRUE} (and fill missing columns with \code{NA}).
#' @param \dots Additional arguments passed to \code{\link{import}}. Behavior may be unexpected if files are of different formats.
#' @return If \code{rbind=FALSE} (the default), a list of a data frames. Otherwise, that list is passed to \code{\link[data.table]{rbindlist}} with \code{fill = TRUE} and returns a data frame object of class set by the \code{setclass} argument; if this operation fails, the list is returned.
#' @examples
#' library('datasets')
#' export(list(mtcars1 = mtcars[1:10,], 
#'             mtcars2 = mtcars[11:20,],
#'             mtcars2 = mtcars[21:32,]), "mtcars.xlsx")
#' 
#' # import a single file from multi-object workbook
#' str(import("mtcars.xlsx", which = "mtcars1"))
#' 
#' # import all worksheets
#' str(import_list("mtcars.xlsx"), 1)
#' 
#' # import and rbind all worksheets
#' mtcars2 <- import_list("mtcars.xlsx", rbind = TRUE)
#' all.equal(mtcars2, mtcars, check.attributes = FALSE)
#' 
#' # import multiple files
#' export(mtcars, "mtcars.csv")
#' export(mtcars, "iris.csv")
#' str(import_list(dir(pattern = "csv$")), 1)
#' 
#' # cleanup
#' unlink("mtcars.xlsx")
#' unlink("mtcars.csv")
#' unlink("iris.csv")
#' 
#' @seealso \code{\link{import}}
#' @export
import_list <- 
function(file, 
         setclass, 
         which, 
         rbind = FALSE, 
         rbind_label = "_file", 
         rbind_fill = TRUE, 
         ...) {
    if (missing(setclass)) {
        setclass <- NULL
    }
    if (length(file) > 1) {
        x <- lapply(file, function(thisfile) {
            out <- try(import(thisfile, setclass = setclass, ...), silent = TRUE)
            if (inherits(out, "try-error")) {
                warning(sprintf("Import failed for %s", thisfile))
                out <- NULL
            } else if (isTRUE(rbind)) {
                out[[rbind_label]] <- thisfile
            }
            out
        })
    } else {
        if (get_ext(file) == "rdata") {
            e <- new.env()
            load(file, envir = e)
            x <- as.list(e)
        } else {
            if (missing(which)) {
                if (get_ext(file) == "html") {
                    requireNamespace("xml2", quietly = TRUE)
                    which <- seq_along(xml2::xml_find_all(xml2::read_html(unclass(file)), ".//table"))
                } else if (get_ext(file) %in% c("xls","xlsx")) {
                    requireNamespace("readxl", quietly = TRUE)
                    which <- seq_along(readxl::excel_sheets(path = file))
                } else if (get_ext(file) %in% c("zip")) {
                    which <- seq_len(nrow(utils::unzip(file, list = TRUE)))
                } else {
                    which <- 1
                }
            }
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
        }
    }
    
    # optionally rbind
    if (isTRUE(rbind)) {
        if (length(x) == 1) {
            x <- x[[1L]]
        } else {
            x2 <- try(data.table::rbindlist(x, fill = rbind_fill), silent = TRUE)
            if (inherits(x2, "try-error")) {
                warnings("Attempt to rbindlist() the data did not succeed. List returned instead.")
                return(x)
            } else {
                x <- x2
            }
        }
        # set class
        a <- list(...)
        if (is.null(setclass)) {
            if ("data.table" %in% names(a) && isTRUE(a[["data.table"]])) {
                x <- set_class(x, class = "data.table")
            } else {
                x <- set_class(x, class = "data.frame")
            }
        } else {
            if ("data.table" %in% names(a) && isTRUE(a[["data.table"]])) {
                if (setclass != "data.table") {
                    warning(sprintf("'data.table = TRUE' argument overruled. Using setclass = '%s'", setclass))
                    x <- set_class(x, class = setclass)
                } else {
                    x <- set_class(x, class = "data.table")
                }
            } else {
                x <- set_class(x, class = setclass)
            }
        }
    }
    
    return(x)
}
