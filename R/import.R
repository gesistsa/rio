#' @rdname import
#' @title Import
#' @description Read in a data.frame from a file
#' @param file A character string naming a file, URL, or single-file .zip or .tar archive.
#' @param format An optional character string code of file format, which can be used to override the format inferred from \code{file}. Shortcuts include: \dQuote{,} (for comma-separated values), \dQuote{;} (for semicolon-separated values), and \dQuote{|} (for pipe-separated values).
#' @param setclass An optional character vector specifying one or more classes to set on the import. By default, all the return object is always a \dQuote{data.frame}. Allowed values for this might be \dQuote{tbl_df}, \dQuote{tbl}, or \dQuote{tibble} (if using dplyr) or \dQuote{data.table} (if using data.table). Other values are ignored such that a data.frame is returned.
#' @param which This argument is used to control import from multi-object files; as a rule \code{import} only ever returns a single data frame. (Use \code{\link{import_list}} to import multiple data frames from a multi-object file.) If \code{file} is a compressed directory, \code{which} can be either a character string specifying a filename or an integer specifying which file (in locale sort order) to extract from the compressed directory. For Excel spreadsheets, this can be used to specify a sheet number. For .Rdata files, this can be an object name. For HTML files, which table to exract (from document order). Ignored otherwise. A character string value will be used as a regular expression, such that the extracted file is the first match of the regular expression against the file names in the archive.
#' @param \dots Additional arguments passed to the underlying import functions. For example, this can control column classes for delimited file types, or control the use of haven for Stata and SPSS or readxl for Excel (.xlsx) format. See details below.
#' @return A data frame. If \code{setclass} is used, this data frame may have additional class attribute values, such as \dQuote{tibble} or \dQuote{data.table}.
#' @details This function imports a data frame or matrix from a data file with the file format based on the file extension (or the manually specified format, if \code{format} is specified).
#'
#' \code{import} supports the following file formats:
#'
#' \itemize{
#'     \item Tab-separated data (.tsv), using \code{\link[data.table]{fread}} or, if \code{fread = FALSE}, \code{\link[utils]{read.table}} with \code{row.names = FALSE} and \code{stringsAsFactors = FALSE}
#'     \item Comma-separated data (.csv), using \code{\link[data.table]{fread}} or, if \code{fread = FALSE}, \code{\link[utils]{read.table}} with \code{row.names = FALSE} and \code{stringsAsFactors = FALSE}
#'     \item gzip comma-separated data (.csv.gz), using \code{\link[utils]{read.table}} with \code{row.names = FALSE} and \code{stringsAsFactors = FALSE}
#'     \item \href{https://github.com/csvy}{CSVY} (CSV with a YAML metadata header) using \code{\link[csvy]{read_csvy}}.
#'     \item Feather R/Python interchange format (.feather), using \code{feather::read_feather}
#'     \item Fast storage (.fst), using \code{\link[fst]{read.fst}}
#'     \item Pipe-separated data (.psv), using \code{\link[data.table]{fread}} or, if \code{fread = FALSE}, \code{\link[utils]{read.table}} with \code{sep = '|'}, \code{row.names = FALSE} and \code{stringsAsFactors = FALSE}
#'     \item Fixed-width format data (.fwf), using a faster version of \code{\link[utils]{read.fwf}} that requires a \code{widths} argument and by default in rio has \code{stringsAsFactors = FALSE}. If \code{readr = TRUE}, import will be performed using \code{\link[readr]{read_fwf}}, where \code{widths} should be: \code{NULL}, a vector of column widths, or the output of \code{\link[readr]{fwf_empty}}, \code{\link[readr]{fwf_widths}}, or \code{\link[readr]{fwf_positions}}.
#'     \item Serialized R objects (.rds), using \code{\link[base]{readRDS}}
#'     \item Saved R objects (.RData,.rda), using \code{\link[base]{load}} for single-object .Rdata files. Use \code{which} to specify an object name for multi-object .Rdata files.
#'     \item JSON (.json), using \code{\link[jsonlite]{fromJSON}}
#'     \item YAML (.yml), using \code{\link[yaml]{yaml.load}}
#'     \item Stata (.dta), using \code{\link[haven]{read_dta}}. If \code{haven = FALSE}, \code{\link[foreign]{read.dta}} can be used.
#'     \item SPSS (.sav), using \code{\link[haven]{read_sav}}. If \code{haven = FALSE}, \code{\link[foreign]{read.spss}} can be used.
#'     \item SPSS Portable Files (.por), using \code{\link[haven]{read_por}}.
#'     \item "XBASE" database files (.dbf), using \code{\link[foreign]{read.dbf}}
#'     \item Weka Attribute-Relation File Format (.arff), using \code{\link[foreign]{read.arff}}
#'     \item R syntax object (.R), using \code{\link[base]{dget}}
#'     \item Matlab (.mat), using \code{\link[rmatio]{read.mat}}
#'     \item Excel (.xls and .xlsx), using \code{\link[readxl]{read_excel}}. If \code{readxl = FALSE}, \code{\link[openxlsx]{read.xlsx}} can be used. Use \code{which} to specify a sheet number.
#'     \item SAS (.sas7bdat) and SAS XPORT (.xpt), using \code{\link[haven]{read_sas}} and \code{\link[foreign]{read.xport}}.
#'     \item Minitab (.mtp), using \code{\link[foreign]{read.mtp}}
#'     \item Epiinfo (.rec), using \code{\link[foreign]{read.epiinfo}}
#'     \item Systat (.syd), using \code{\link[foreign]{read.systat}}
#'     \item Data Interchange Format (.dif), using \code{\link[utils]{read.DIF}}
#'     \item OpenDocument Spreadsheet (.ods), using \code{\link[readODS]{read_ods}}.  Use \code{which} to specify a sheet number.
#'     \item Shallow XML documents (.xml), using \code{\link[xml2]{read_xml}}. The data structure will only be read correctly if the XML file can be converted to a list via \code{\link[xml2]{as_list}}.
#'     \item Single-table HTML documents (.html), using \code{\link[xml2]{read_html}}. The data structure will only be read correctly if the HTML file can be converted to a list via \code{\link[xml2]{as_list}}.
#'     \item Clipboard import (on Windows and Mac OS), using \code{\link[utils]{read.table}} with \code{row.names = FALSE}
#'     \item Fortran data (no recognized extension), using \code{\link[utils]{read.fortran}}
#'     \item Google Sheets, as Comma-separated data (.csv)
#' }
#'
#' \code{import} attempts to standardize the return value from the various import functions to the extent possible, thus providing a uniform data structure regardless of what import package or function is used. It achieves this by storing any optional variable-related attributes at the variable level (i.e., an attribute for \code{mtcars$mpg} is stored in \code{attributes(mtcars$mpg)} rather than \code{attributes(mtcars)}). If you would prefer these attributes to be stored at the data.frame-level (i.e., in \code{attributes(mtcars)}), see \code{\link{gather_attrs}}.
#'
#' @note For csv and txt files with row names exported from \code{\link{export}}, it may be helpful to specify \code{row.names} as the column of the table which contain row names. See example below.
#' @examples
#' # create CSV to import
#' export(iris, "iris1.csv")
#'
#' # specify `format` to override default format
#' export(iris, "iris.tsv", format = "csv")
#' stopifnot(identical(import("iris1.csv"), import("iris.tsv", format = "csv")))
#'
#' # import CSV as a `data.table`
#' stopifnot(inherits(import("iris1.csv", setclass = "data.table"), "data.table"))
#' stopifnot(inherits(import("iris1.csv", setclass = "data.table"), "data.table"))
#'
#' # pass arguments to underlying import function
#' iris1 <- import("iris1.csv")
#' identical(names(iris), names(iris1))
#'
#' export(iris, "iris2.csv", col.names = FALSE)
#' iris2 <- import("iris2.csv")
#' identical(names(iris), names(iris2))
#'
#' # set class for the response data.frame as "tbl_df" (from dplyr)
#' stopifnot(inherits(import("iris1.csv", setclass = "tbl_df"), "tbl_df"))
#'
#' # cleanup
#' unlink("iris.tsv")
#' unlink("iris1.csv")
#' unlink("iris2.csv")
#'
#' @seealso \code{\link{import_list}}, \code{\link{.import}}, \code{\link{gather_attrs}}, \code{\link{export}}, \code{\link{convert}}
#' @importFrom tools file_ext file_path_sans_ext
#' @importFrom stats na.omit setNames
#' @importFrom utils installed.packages untar unzip tar zip type.convert capture.output
#' @importFrom curl curl_fetch_memory parse_headers
#' @importFrom data.table as.data.table is.data.table
#' @importFrom tibble as_tibble is_tibble
#' @export
import <- function(file, format, setclass, which, ...) {
    if (grepl("^http.*://", file)) {
        file <- remote_to_local(file, format = format)
    }
    if ((file != "clipboard") && !file.exists(file)) {
        stop("No such file")
    }
    if (grepl("\\.zip$", file)) {
        if (missing(which)) {
            file <- parse_zip(file)
        } else {
            file <- parse_zip(file, which = which)
        }
    } else if(grepl("\\.tar", file)) {
        if (missing(which)) {
            which <- 1
        }
        file <- parse_tar(file, which = which)
    }
    if (missing(format)) {
        fmt <- get_ext(file)
        if (fmt %in% c("gz", "gzip")) {
            fmt <- file_ext(file_path_sans_ext(file, compression = FALSE))
            file <- gzfile(file)
        }
    } else {
        fmt <- get_type(format)
    }

    class(file) <- c(paste0("rio_", fmt), class(file))
    if (missing(which)) {
        x <- .import(file = file, ...)
    } else {
        x <- .import(file = file, which = which, ...)
    }

    if (missing(setclass)) {
        return(set_class(x))
    }

    a <- list(...)
    if ("data.table" %in% names(a) && isTRUE(a[["data.table"]])) {
        setclass <- "data.table"
    }
    return(set_class(x, class = setclass))
}
