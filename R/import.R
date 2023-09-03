#' @rdname import
#' @title Import
#' @description Read in a data.frame from a file. Exceptions to this rule are Rdata, RDS, and JSON input file formats, which return the originally saved object without changing its class.
#' @param file A character string naming a file, URL, or single-file .zip or .tar archive.
#' @param format An optional character string code of file format, which can be used to override the format inferred from `file`. Shortcuts include: \dQuote{,} (for comma-separated values), \dQuote{;} (for semicolon-separated values), and \dQuote{|} (for pipe-separated values).
#' @param setclass An optional character vector specifying one or more classes to set on the import. By default, the return object is always a \dQuote{data.frame}. Allowed values include \dQuote{tbl_df}, \dQuote{tbl}, or \dQuote{tibble} (if using dplyr) or \dQuote{data.table} (if using data.table). Other values are ignored, such that a data.frame is returned.
#' @param which This argument is used to control import from multi-object files; as a rule `import` only ever returns a single data frame (use [import_list()] to import multiple data frames from a multi-object file). If `file` is a compressed directory, `which` can be either a character string specifying a filename or an integer specifying which file (in locale sort order) to extract from the compressed directory. For Excel spreadsheets, this can be used to specify a sheet name or number. For .Rdata files, this can be an object name. For HTML files, it identifies which table to extract (from document order). Ignored otherwise. A character string value will be used as a regular expression, such that the extracted file is the first match of the regular expression against the file names in the archive.
#' @param \dots Additional arguments passed to the underlying import functions. For example, this can control column classes for delimited file types, or control the use of haven for Stata and SPSS or readxl for Excel (.xlsx) format. See details below.
#' @return A data frame. If `setclass` is used, this data frame may have additional class attribute values, such as \dQuote{tibble} or \dQuote{data.table}.
#' @details This function imports a data frame or matrix from a data file with the file format based on the file extension (or the manually specified format, if `format` is specified).
#'
#' `import` supports the following file formats:
#'
#' \itemize{
#'     \item Comma-separated data (.csv), using [data.table::fread()] or, if `fread = FALSE`, [utils::read.table()] with `row.names = FALSE` and `stringsAsFactors = FALSE`
#'     \item Pipe-separated data (.psv), using [data.table::fread()] or, if `fread = FALSE`, [utils::read.table()] with `sep = '|'`, `row.names = FALSE` and `stringsAsFactors = FALSE`
#'     \item Tab-separated data (.tsv), using [data.table::fread()] or, if `fread = FALSE`, [utils::read.table()] with `row.names = FALSE` and `stringsAsFactors = FALSE`
#'     \item SAS (.sas7bdat), using [haven::read_sas()].
#'     \item SAS XPORT (.xpt), using [haven::read_xpt()] or, if `haven = FALSE`, [foreign::read.xport()].
#'     \item SPSS (.sav), using [haven::read_sav()]. If `haven = FALSE`, [foreign::read.spss()] can be used.
#'     \item SPSS compressed (.zsav), using [haven::read_sav()].
#'     \item Stata (.dta), using [haven::read_dta()]. If `haven = FALSE`, [foreign::read.dta()] can be used.
#'     \item SPSS Portable Files (.por), using [haven::read_por()].
#'     \item Excel (.xls and .xlsx), using [readxl::read_excel()]. Use `which` to specify a sheet number. For .xlsx files, it is possible to set `readxl = FALSE`, so that [openxlsx::read.xlsx()] can be used instead of readxl (the default).
#'     \item R syntax object (.R), using [base::dget()]
#'     \item Saved R objects (.RData,.rda), using [base::load()] for single-object .Rdata files. Use `which` to specify an object name for multi-object .Rdata files. This can be any R object (not just a data frame).
#'     \item Serialized R objects (.rds), using [base::readRDS()]. This can be any R object (not just a data frame).
#'     \item Epiinfo (.rec), using [foreign::read.epiinfo()]
#'     \item Minitab (.mtp), using [foreign::read.mtp()]
#'     \item Systat (.syd), using [foreign::read.systat()]
#'     \item "XBASE" database files (.dbf), using [foreign::read.dbf()]
#'     \item Weka Attribute-Relation File Format (.arff), using [foreign::read.arff()]
#'     \item Data Interchange Format (.dif), using [utils::read.DIF()]
#'     \item Fortran data (no recognized extension), using [utils::read.fortran()]
#'     \item Fixed-width format data (.fwf), using a faster version of [utils::read.fwf()] that requires a `widths` argument and by default in rio has `stringsAsFactors = FALSE`. If `readr = TRUE`, import will be performed using [readr::read_fwf()], where `widths` should be: `NULL`, a vector of column widths, or the output of [readr::fwf_empty()], [readr::fwf_widths()], or [readr::fwf_positions()].
#'     \item gzip comma-separated data (.csv.gz), using [utils::read.table()] with `row.names = FALSE` and `stringsAsFactors = FALSE`
#'     \item [CSVY](https://github.com/csvy) (CSV with a YAML metadata header) using [data.table::fread()].
#'     \item Apache Arrow Parquet (.parquet), using [arrow::read_parquet()]
#'     \item Feather R/Python interchange format (.feather), using [feather::read_feather()]
#'     \item Fast storage (.fst), using [fst::read.fst()]
#'     \item JSON (.json), using [jsonlite::fromJSON()]
#'     \item Matlab (.mat), using [rmatio::read.mat()]
#'     \item EViews (.wf1), using [hexView::readEViews()]
#'     \item OpenDocument Spreadsheet (.ods), using [readODS::read_ods()].  Use `which` to specify a sheet number.
#'     \item Single-table HTML documents (.html), using [xml2::read_html()]. There is no standard HTML table and we have only tested this with HTML tables exported with this package. HTML tables will only be read correctly if the HTML file can be converted to a list via [xml2::as_list()]. This import feature is not robust, especially for HTML tables in the wild. Please use a proper web scraping framework, e.g. `rvest`.
#'     \item Shallow XML documents (.xml), using [xml2::read_xml()]. The data structure will only be read correctly if the XML file can be converted to a list via [xml2::as_list()].
#'     \item YAML (.yml), using [yaml::yaml.load()]
#'     \item Clipboard import, using [utils::read.table()] with `row.names = FALSE`
#'     \item Google Sheets, as Comma-separated data (.csv)
#'     \item GraphPad Prism (.pzfx) using [pzfx::read_pzfx()]
#' }
#'
#' `import` attempts to standardize the return value from the various import functions to the extent possible, thus providing a uniform data structure regardless of what import package or function is used. It achieves this by storing any optional variable-related attributes at the variable level (i.e., an attribute for `mtcars$mpg` is stored in `attributes(mtcars$mpg)` rather than `attributes(mtcars)`). If you would prefer these attributes to be stored at the data.frame-level (i.e., in `attributes(mtcars)`), see [gather_attrs()].
#'
#' After importing metadata-rich file formats (e.g., from Stata or SPSS), it may be helpful to recode labelled variables to character or factor using [characterize()] or [factorize()] respectively.
#'
#' @note For csv and txt files with row names exported from [export()], it may be helpful to specify `row.names` as the column of the table which contain row names. See example below.
#' @examples
#' ## For demo, a temp. file path is created with the file extension .csv
#' csv_file <- tempfile(fileext = ".csv")
#' ## .xlsx
#' xlsx_file <- tempfile(fileext = ".xlsx")
#' ## create CSV to import
#' export(iris, csv_file)
#' ## specify `format` to override default format: see export()
#' export(iris, xlsx_file, format = "csv")
#'
#' ## basic
#' import(csv_file)
#'
#' ## You can certainly import your data with the file name, which is not a variable:
#' ## import("starwars.csv"); import("mtcars.xlsx")
#'
#' ## Override the default format
#' ## import(xlsx_file) # Error, it is actually not an Excel file
#' import(xlsx_file, format = "csv")
#'
#' ## import CSV as a `data.table`
#' import(csv_file, setclass = "data.table")
#'
#' ## import CSV as a tibble (or "tbl_df")
#' import(csv_file, setclass = "tbl_df")
#'
#' ## pass arguments to underlying import function
#' ## data.table::fread is the underlying import function and `nrows` is its argument
#' import(csv_file, nrows = 20)
#' @seealso [import_list()], [characterize()], [gather_attrs()], [export()], [convert()]
#' @importFrom tools file_ext file_path_sans_ext
#' @importFrom stats na.omit setNames
#' @importFrom utils installed.packages untar unzip tar zip type.convert capture.output
#' @importFrom curl curl_fetch_memory parse_headers
#' @importFrom data.table as.data.table is.data.table
#' @importFrom tibble as_tibble is_tibble
#' @export
import <- function(file, format, setclass, which, ...) {
    .check_file(file, single_only = TRUE)
    if (grepl("^http.*://", file)) {
        file <- remote_to_local(file, format = format)
    }
    if ((file != "clipboard") && !file.exists(file)) {
        stop("No such file: ", file, call. = FALSE)
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
            fmt <- tools::file_ext(tools::file_path_sans_ext(file, compression = FALSE))
            file <- gzfile(file)
        } else {
            fmt <- get_type(fmt)
        }
    } else {
        fmt <- get_type(format)
    }

    args_list <- list(...)

    class(file) <- c(paste0("rio_", fmt), class(file))
    if (missing(which)) {
        x <- .import(file = file, ...)
    } else {
        x <- .import(file = file, which = which, ...)
    }

    # if R serialized object, just return it without setting object class
    if (inherits(file, c("rio_rdata", "rio_rds", "rio_json"))) {
        return(x)
    }
    # otherwise, make sure it's a data frame (or requested class)
    if (missing(setclass) || is.null(setclass)) {
        if ("data.table" %in% names(args_list) && isTRUE(args_list[["data.table"]])) {
            return(set_class(x, class = "data.table"))
        } else {
            return(set_class(x, class = "data.frame"))
        }
    } else {
        if ("data.table" %in% names(args_list) && isTRUE(args_list[["data.table"]])) {
            if (setclass != "data.table") {
                warning(sprintf("'data.table = TRUE' argument overruled. Using setclass = '%s'", setclass))
                return(set_class(x, class = setclass))
            } else {
                return(set_class(x, class = "data.table"))
            }
        } else {
            return(set_class(x, class = setclass))
        }
    }
}
