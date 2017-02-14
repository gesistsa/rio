#' @rdname export
#' @title Export
#' @description Write data.frame to a file
#' @param x A data frame or matrix to be written into a file.
#' @param file A character string naming a file. Must specify \code{file} and/or \code{format}.
#' @param format An optional character string containing the file format, which can be used to override the format inferred from \code{file} or, in lieu of specifying \code{file}, a file with the symbol name of \code{x} and the specified file extension will be created. Must specify \code{file} and/or \code{format}. Shortcuts include: \dQuote{,} (for comma-separated values), \dQuote{;} (for semicolon-separated values), \dQuote{|} (for pipe-separated values), and \dQuote{dump} for \code{\link[base]{dump}}.
#' @param \dots Additional arguments for the underlying export functions.
#' @return The name of the output file as a character string (invisibly).
#' @details This function exports a data frame or matrix into a file with file format based on the file extension (or the manually specified format, if \code{format} is specified).
#'
#' The output file can be to a compressed directory, simply by adding an appropriate additional extensiont to the \code{file} argument, such as: \dQuote{mtcars.csv.tar}, \dQuote{mtcars.csv.zip}, or \dQuote{mtcars.csv.gz}.
#'
#' \code{export} supports many file formats. See the documentation for the underlying export functions for optional arguments that can be passed via \code{...}
#'
#' \itemize{
#'     \item Tab-separated data (.tsv), using \code{\link[data.table]{fwrite}} or, if \code{fwrite = TRUE}, \code{\link[utils]{write.table}} with \code{row.names = FALSE}.
#'     \item Comma-separated data (.csv), using \code{\link[data.table]{fwrite}} or, if \code{fwrite = TRUE}, \code{\link[utils]{write.csv}} with \code{row.names = FALSE}.
#'     \item \href{https://github.com/csvy}{CSVY} (CSV with a YAML metadata header) using \code{\link[csvy]{write_csvy}}. The YAML header lines are preceded by R comment symbols (\#) by default; this can be turned off by passing a \code{comment_header = FALSE} argument to \code{export}. Setting \code{fwrite = TRUE} (the default) will rely on \code{\link[data.table]{fwrite}} for much faster export.
#'     \item Pipe-separated data (.psv), using \code{\link[data.table]{fwrite}} or, if \code{fwrite = TRUE}, \code{\link[utils]{write.table}} with \code{sep = '|'} and \code{row.names = FALSE}.
#'     \item Feather R/Python interchange format (.feather), using \code{feather::write_feather}
#'     \item Fixed-width format data (.fwf), using \code{\link[utils]{write.table}} with \code{row.names = FALSE}, \code{quote = FALSE}, and \code{col.names = FALSE}
#'     \item Serialized R objects (.rds), using \code{\link[base]{saveRDS}}
#'     \item Saved R objects (.RData,.rda), using \code{\link[base]{save}}
#'     \item JSON (.json), using \code{\link[jsonlite]{toJSON}}
#'     \item YAML (.yml), using \code{\link[yaml]{as.yaml}}
#'     \item Stata (.dta), using \code{\link[haven]{write_dta}}. Note that variable/column names containing dots (.) are not allowed and will produce an error.
#'     \item SPSS (.sav), using \code{\link[haven]{write_sav}}
#'     \item SAS (.sas7bdat), using \code{\link[haven]{write_sas}}.
#'     \item "XBASE" database files (.dbf), using \code{\link[foreign]{write.dbf}}
#'     \item Weka Attribute-Relation File Format (.arff), using \code{\link[foreign]{write.arff}}
#'     \item R syntax object (.R), using \code{\link[base]{dput}} (by default) or \code{\link[base]{dump}} (if \code{format = 'dump'}
#'     \item Excel (.xlsx), using \code{\link[openxlsx]{write.xlsx}}
#'     \item OpenDocument Spreadsheet (.ods), using \code{\link[readODS]{write_ods}}. (Currently only single-sheet exports are supported.)
#'     \item XML (.xml), using a custom method based on \code{\link[xml2]{xml_add_child}} to create a simple XML tree and \code{\link[xml2]{write_xml}} to write to disk.
#'     \item HTML (.html), using a custom method based on \code{\link[xml2]{xml_add_child}} to create a simple HTML table and \code{\link[xml2]{write_xml}} to write to disk.
#'     \item Clipboard export (on Windows and Mac OS), using \code{\link[utils]{write.table}} with \code{row.names = FALSE}
#' }
#'
#' @examples
#' # specify only `file` argument
#' export(mtcars, "mtcars.csv")
#'
#' \dontrun{
#' # Stata does not recognize variables names with '.'
#' export(mtcars, "mtcars.dta")
#' }
#'
#' # specify only `format` argument
#' "mtcars.dta" %in% dir()
#' export(mtcars, format = "stata")
#' "mtcars.dta" %in% dir()
#'
#' # specify `file` and `format` to override default format
#' export(mtcars, file = "mtcars.txt", format = "csv")
#'
#' # export to JSON
#' export(mtcars, "mtcars.json")
#'
#' # pass arguments to underlying export function
#' export(mtcars, "mtcars.csv", col.names = FALSE)
#'
#' # write data to .R syntax file and append additional data
#' export(mtcars, file = "data.R", format = "dump")
#' export(mtcars, file = "data.R", format = "dump", append = TRUE)
#' source("data.R", echo = TRUE)
#'
#' # write data to a zip-compressed CSV
#' export(mtcars, "mtcars.csv.zip")
#'
#' # cleanup
#' unlink("mtcars.csv")
#' unlink("mtcars.dta")
#' unlink("mtcars.json")
#' unlink("data.R")
#' unlink("mtcars.csv.zip")
#' @seealso \code{\link{.export}}, \code{\link{import}}, \code{\link{convert}}
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
    if (fmt %in% c("gz", "gzip")) {
        fmt <- file_ext(file_path_sans_ext(file, compression = FALSE))
        file <- gzfile(file, "w")
        on.exit(close(file))
    }

    if (!is.data.frame(x) & !is.matrix(x)) {
        stop("'x' is not a data.frame or matrix")
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

    invisible(unclass(file))
}
