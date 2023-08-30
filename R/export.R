#' @rdname export
#' @title Export
#' @description Write data.frame to a file
#' @param x A data frame or matrix to be written into a file. Exceptions to this rule are that \code{x} can be a list of data frames if the output file format is an Excel .xlsx workbook, .Rdata file, or HTML file, or a variety of R objects if the output file format is RDS or JSON. See examples.) To export a list of data frames to multiple files, use \code{\link{export_list}} instead.
#' @param file A character string naming a file. Must specify \code{file} and/or \code{format}.
#' @param format An optional character string containing the file format, which can be used to override the format inferred from \code{file} or, in lieu of specifying \code{file}, a file with the symbol name of \code{x} and the specified file extension will be created. Must specify \code{file} and/or \code{format}. Shortcuts include: \dQuote{,} (for comma-separated values), \dQuote{;} (for semicolon-separated values), \dQuote{|} (for pipe-separated values), and \dQuote{dump} for \code{\link[base]{dump}}.
#' @param \dots Additional arguments for the underlying export functions. This can be used to specify non-standard arguments. See examples.
#' @return The name of the output file as a character string (invisibly).
#' @details This function exports a data frame or matrix into a file with file format based on the file extension (or the manually specified format, if \code{format} is specified).
#'
#' The output file can be to a compressed directory, simply by adding an appropriate additional extensiont to the \code{file} argument, such as: \dQuote{mtcars.csv.tar}, \dQuote{mtcars.csv.zip}, or \dQuote{mtcars.csv.gz}.
#'
#' \code{export} supports many file formats. See the documentation for the underlying export functions for optional arguments that can be passed via \code{...}
#'
#' \itemize{
#'     \item Comma-separated data (.csv), using \code{\link[data.table]{fwrite}} or, if \code{fwrite = TRUE}, \code{\link[utils]{write.table}} with \code{row.names = FALSE}.
#'     \item Pipe-separated data (.psv), using \code{\link[data.table]{fwrite}} or, if \code{fwrite = TRUE}, \code{\link[utils]{write.table}} with \code{sep = '|'} and \code{row.names = FALSE}.
#'     \item Tab-separated data (.tsv), using \code{\link[data.table]{fwrite}} or, if \code{fwrite = TRUE}, \code{\link[utils]{write.table}} with \code{row.names = FALSE}.
#'     \item SAS (.sas7bdat), using \code{\link[haven]{write_sas}}.
#'     \item SAS XPORT (.xpt), using \code{\link[haven]{write_xpt}}.
#'     \item SPSS (.sav), using \code{\link[haven]{write_sav}}
#'     \item SPSS compressed (.zsav), using \code{\link[haven]{write_sav}}
#'     \item Stata (.dta), using \code{\link[haven]{write_dta}}. Note that variable/column names containing dots (.) are not allowed and will produce an error.
#'     \item Excel (.xlsx), using \code{\link[openxlsx]{write.xlsx}}. Existing workbooks are overwritten unless \code{which} is specified, in which case only the specified sheet (if it exists) is overwritten. If the file exists but the \code{which} sheet does not, data are added as a new sheet to the existing workbook. \code{x} can also be a list of data frames; the list entry names are used as sheet names.
#'     \item R syntax object (.R), using \code{\link[base]{dput}} (by default) or \code{\link[base]{dump}} (if \code{format = 'dump'})
#'     \item Saved R objects (.RData,.rda), using \code{\link[base]{save}}. In this case, \code{x} can be a data frame, a named list of objects, an R environment, or a character vector containing the names of objects if a corresponding \code{envir} argument is specified.
#'     \item Serialized R objects (.rds), using \code{\link[base]{saveRDS}}. In this case, \code{x} can be any serializable R object.
#'     \item "XBASE" database files (.dbf), using \code{\link[foreign]{write.dbf}}
#'     \item Weka Attribute-Relation File Format (.arff), using \code{\link[foreign]{write.arff}}
#'     \item Fixed-width format data (.fwf), using \code{\link[utils]{write.table}} with \code{row.names = FALSE}, \code{quote = FALSE}, and \code{col.names = FALSE}
#'     \item gzip comma-separated data (.csv.gz), using \code{\link[utils]{write.table}} with \code{row.names = FALSE}
#'     \item \href{https://github.com/csvy}{CSVY} (CSV with a YAML metadata header) using \code{\link[data.table]{fwrite}}.
#'     \item Apache Arrow Parquet (.parquet), using \code{\link[arrow]{write_parquet}}
#'     \item Feather R/Python interchange format (.feather), using \code{\link[feather]{write_feather}}
#'     \item Fast storage (.fst), using \code{\link[fst]{write.fst}}
#'     \item JSON (.json), using \code{\link[jsonlite]{toJSON}}. In this case, \code{x} can be a variety of R objects, based on class mapping conventions in this paper: \href{https://arxiv.org/abs/1403.2805}{https://arxiv.org/abs/1403.2805}.
#'     \item Matlab (.mat), using \code{\link[rmatio]{write.mat}}
#'     \item OpenDocument Spreadsheet (.ods), using \code{\link[readODS]{write_ods}}. (Currently only single-sheet exports are supported.)
#'     \item HTML (.html), using a custom method based on \code{\link[xml2]{xml_add_child}} to create a simple HTML table and \code{\link[xml2]{write_xml}} to write to disk.
#'     \item XML (.xml), using a custom method based on \code{\link[xml2]{xml_add_child}} to create a simple XML tree and \code{\link[xml2]{write_xml}} to write to disk.
#'     \item YAML (.yml), using \code{\link[yaml]{as.yaml}}
#'     \item Clipboard export (on Windows and Mac OS), using \code{\link[utils]{write.table}} with \code{row.names = FALSE}
#' }
#'
#' When exporting a data set that contains label attributes (e.g., if imported from an SPSS or Stata file) to a plain text file, \code{\link{characterize}} can be a useful pre-processing step that records value labels into the resulting file (e.g., \code{export(characterize(x), "file.csv")}) rather than the numeric values.
#'
#' Use \code{\link{export_list}} to export a list of dataframes to separate files.
#'
#' @examples
#' library("datasets")
#' # specify only `file` argument
#' export(mtcars, f1 <- tempfile(fileext = ".csv"))
#'
#' \dontrun{
#' wd <- getwd()
#' setwd(tempdir())
#' # Stata does not recognize variables names with '.'
#' export(mtcars, f2 <- tempfile(fileext = ".dta"))
#'
#' # specify only `format` argument
#' f2 %in% tempdir()
#' export(mtcars, format = "stata")
#' "mtcars.dta" %in% dir()
#'
#' setwd(wd)
#' }
#' # specify `file` and `format` to override default format
#' export(mtcars, file = f3 <- tempfile(fileext = ".txt"), format = "csv")
#'
#' # export multiple objects to Rdata
#' export(list(mtcars = mtcars, iris = iris), f4 <- tempfile(fileext = ".rdata"))
#' export(c("mtcars", "iris"), f4)
#'
#' # export to non-data frame R object to RDS or JSON
#' export(mtcars$cyl, f5 <- tempfile(fileext = ".rds"))
#' export(list(iris, mtcars), f6 <- tempfile(fileext = ".json"))
#'
#' # pass arguments to underlying export function
#' export(mtcars, f7 <- tempfile(fileext = ".csv"), col.names = FALSE)
#'
#' # write data to .R syntax file and append additional data
#' export(mtcars, file = f8 <- tempfile(fileext = ".R"), format = "dump")
#' export(mtcars, file = f8, format = "dump", append = TRUE)
#' source(f8, echo = TRUE)
#'
#' # write to an Excel workbook
#' \dontrun{
#'   ## export a single data frame
#'   export(mtcars, f9 <- tempfile(fileext = ".xlsx"))
#'
#'   ## export NAs to Excel as missing via args passed to `...`
#'   mtcars$drat <- NA_real_
#'   mtcars %>% export(f10 <- tempfile(fileext = ".xlsx"), keepNA = TRUE)
#'
#'   ## export a list of data frames as worksheets
#'   export(list(a = mtcars, b = iris), f11 <- tempfile(fileext = ".xlsx"))
#'
#'   ## export, adding a new sheet to an existing workbook
#'   export(iris, f12 <- tempfile(fileext = ".xlsx"), which = "iris")
#' }
#'
#' # write data to a zip-compressed CSV
#' export(mtcars, f13 <- tempfile(fileext = ".csv.zip"))
#'
#' # cleanup
#' unlink(f1)
#' # unlink(f2)
#' unlink(f3)
#' unlink(f4)
#' unlink(f5)
#' unlink(f6)
#' unlink(f7)
#' unlink(f8)
#' # unlink(f9)
#' # unlink(f10)
#' # unlink(f11)
#' # unlink(f12)
#' # unlink(f13)
#' @seealso \code{\link{characterize}}, \code{\link{import}}, \code{\link{convert}}, \code{\link{export_list}}
#' @importFrom haven labelled
#' @export
export <- function(x, file, format, ...) {
    if (missing(file) & missing(format)) {
        stop("Must specify 'file' and/or 'format'")
    } else if (!missing(file) & !missing(format)) {
        fmt <- tolower(format)
        cfile <- file
        f <- find_compress(file)
        file <- f$file
        compress <- f$compress
    } else if (!missing(file) & missing(format)) {
        cfile <- file
        f <- find_compress(file)
        file <- f$file
        compress <- f$compress
        fmt <- get_ext(file)
    } else if (!missing(format)) {
        fmt <- get_type(format)
        file <- paste0(as.character(substitute(x)), ".", fmt)
        compress <- NA_character_
    }
    fmt <- get_type(fmt)
    outfile <- file
    if (fmt %in% c("gz", "gzip")) {
        fmt <- tools::file_ext(tools::file_path_sans_ext(file, compression = FALSE))
        file <- gzfile(file, "w")
        on.exit(close(file))
    }

    data_name <- as.character(substitute(x))
    if (!is.data.frame(x) & !is.matrix(x)) {
        if (!fmt %in% c("xlsx", "html", "rdata", "rds", "json")) {
            stop("'x' is not a data.frame or matrix")
        }
    } else if (is.matrix(x)) {
        x <- as.data.frame(x)
    }

    class(file) <- c(paste0("rio_", fmt), class(file))
    .export(file = file, x = x, ...)

    if (!is.na(compress)) {
        cfile <- compress_out(cfile = cfile, filename = file, type = compress)
        unlink(file)
        return(invisible(cfile))
    }

    invisible(unclass(outfile))
}
