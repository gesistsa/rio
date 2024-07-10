.docall <- function(.fcn, ..., args = NULL, alwaysArgs = NULL, .functions = list(.fcn),
                    .ignoreUnusedArgs = TRUE) {
    ## the same as R.utils::doCall, only with default option
    R.utils::doCall(.fcn = .fcn, ..., args = args, alwaysArgs = alwaysArgs, .functions = .functions,
                    .ignoreUnusedArgs = getOption("rio.ignoreunusedargs", default = TRUE))
}

.remap_tidy_convention <- function(func, file, which, header, ...) {
    dots <- list(...)
    if ("path" %in% names(dots)) {
        dots[["path"]] <- NULL
    }
    if ("sheet" %in% names(dots)) {
        which <- dots[["sheet"]]
        dots[["sheet"]] <- NULL
    }
    if ("col_names" %in% names(dots)) {
        header <- dots[["col_names"]]
        dots[["col_names"]] <- NULL
    }
    .docall(func, args = c(dots, list(path = file, sheet = which, col_names = header)))
}

import_delim <- function(file, which = 1, sep = "auto", header = "auto", stringsAsFactors = FALSE, data.table = FALSE, ...) {
    .docall(data.table::fread, ..., args = list(input = file, sep = sep, header = header,
                  stringsAsFactors = stringsAsFactors,
                  data.table = data.table))
}

#' @export
.import.rio_dat <- function(file, which = 1, ...) {
    message(sprintf("Ambiguous file format ('.dat'), but attempting 'data.table::fread(\"%s\")'\n", file))
    import_delim(file = file, ...)
}

#' @export
.import.rio_tsv <- function(file, sep = "auto", which = 1, fread = lifecycle::deprecated(), dec = if (sep %in% c("\t", "auto")) "." else ",", ...) {
    if (lifecycle::is_present(fread)) {
        lifecycle::deprecate_warn(when = "0.5.31", what = "import(fread)", details = "tsv will always be read by `data.table:fread()`. The parameter `fread` will be dropped in v2.0.0.")
    }
    import_delim(file = file, sep = sep, dec = dec, ...)
}

#' @export
.import.rio_txt <- function(file, sep = "auto", which = 1, fread = lifecycle::deprecated(), dec = if (sep %in% c(",", "auto")) "." else ",", ...) {
    if (lifecycle::is_present(fread)) {
        lifecycle::deprecate_warn(when = "0.5.31", what = "import(fread)", details = "txt will always be read by `data.table:fread()`. The parameter `fread` will be dropped in v2.0.0.")
    }
    import_delim(file = file, sep = sep, dec = dec, ...)
}

#' @export
.import.rio_csv <- function(file, sep = ",", which = 1, fread = lifecycle::deprecated(), dec = if (sep %in% c(",", "auto")) "." else ",", ...) {
    if (lifecycle::is_present(fread)) {
        lifecycle::deprecate_warn(when = "0.5.31", what = "import(fread)", details = "csv will always be read by `data.table:fread()`. The parameter `fread` will be dropped in v2.0.0.")
    }
    import_delim(file = file, sep = if (sep == ",") "auto" else sep, dec = dec, ...)
}

#' @export
.import.rio_csv2 <- function(file, sep = ";", which = 1, fread = lifecycle::deprecated(), dec = if (sep %in% c(";", "auto")) "," else ".", ...) {
    if (lifecycle::is_present(fread)) {
        lifecycle::deprecate_warn(when = "0.5.31", what = "import(fread)", details = "csv2 will always be read by `data.table:fread()`. The parameter `fread` will be dropped in v2.0.0.")
    }
    import_delim(file = file, sep = if (sep == ";") "auto" else sep, dec = dec, ...)
}

#' @export
.import.rio_csvy <- function(file, sep = ",", which = 1, fread = lifecycle::deprecated(), dec = if (sep %in% c(",", "auto")) "." else ",", yaml = TRUE, ...) {
    if (lifecycle::is_present(fread)) {
        lifecycle::deprecate_warn(when = "0.5.31", what = "import(fread)", details = "csvy will always be read by `data.table:fread()`. The parameter `fread` will be dropped in v2.0.0.")
    }
    import_delim(file = file, sep = if (sep == ",") "auto" else sep, dec = dec, yaml = yaml, ...)
}

#' @export
.import.rio_psv <- function(file, sep = "|", which = 1, fread = lifecycle::deprecated(), dec = if (sep %in% c("|", "auto")) "." else ",", ...) {
    if (lifecycle::is_present(fread)) {
        lifecycle::deprecate_warn(when = "0.5.31", what = "import(fread)", details = "psv will always be read by `data.table:fread()`. The parameter `fread` will be dropped in v2.0.0.")
    }
    import_delim(file = file, sep = if (sep == "|") "auto" else sep, dec = dec, ...)
}

.get_col_position <- function(file, widths, col_names, col_position) {
    if (missing(col_names)) {
        col_names <- NULL
    }
    if (!is.null(col_position)) {
        return(col_position)
    }
    if (is.list(widths) && isFALSE(c("begin", "end") %in% names(widths))) {
        return(readr::fwf_widths(widths, col_names = col_names))
    }
    if (isTRUE(is.numeric(widths))) {
        return(readr::fwf_widths(abs(widths), col_names = col_names))
    }
    return(readr::fwf_empty(file = file, col_names = col_names))
}

.fix_col_types <- function(col_types, widths) {
    if (isFALSE(is.numeric(widths))) {
        return(col_types)
    }
    col_types <- rep("?", length(widths))
    col_types[widths < 0] <- "?"
    col_types <- paste0(col_types, collapse = "")
    return(col_types)
}

#' @export
.import.rio_fwf <- function(file, which = 1, widths = NULL, col_names, col_types = NULL, col_positions, col.names, col_position = NULL, comment = "#", ...) {
    if (!is.null(widths)) {
        lifecycle::deprecate_warn(when = "1.0.2", what = "import(widths)", details = "`widths` is kept for backward compatibility. Please use `col_positions` or unset `widths` to allow automatic guessing, see `?readr::read_fwf`. The parameter `widths` will be dropped in v2.0.0.")
    }
    if (!missing(col.names)) {
        lifecycle::deprecate_warn(when = "1.0.2", what = "import(widths)", details = "`col.names` is kept for backward compatibility. Please use `col_names`. The parameter `col.names` will be dropped in v2.0.0.")
        col_names <- col.names
    }
    col_positions <- .get_col_position(file = file, widths = widths, col_names = col_names, col_position = col_position)
    if (!is.null(widths) && !is.null(col_types)) {
        col_types <- .fix_col_types(col_types, widths)
    }
    .docall(readr::read_fwf, ..., args = list(file = file, col_positions = col_positions, col_types = col_types, comment = comment))
}

#' @export
.import.rio_r <- function(file, which = 1, trust = getOption("rio.import.trust", default = NULL), ...) {
    .check_trust(trust, format = ".R")
    .docall(dget, ..., args = list(file = file))
}

#' @export
.import.rio_dump <- function(file, which = 1, envir = new.env(), trust = getOption("rio.import.trust", default = NULL), ...) {
    .check_trust(trust, format = "dump")
    source(file = file, local = envir)
    if (missing(which)) {
        if (length(ls(envir)) > 1) {
            warning("Dump file contains multiple objects. Returning first object.")
        }
        which <- 1
    }
    if (is.numeric(which)) {
        get(ls(envir)[which], envir)
    } else {
        get(ls(envir)[grep(which, ls(envir))[1]], envir)
    }
}

#' @export
.import.rio_rds <- function(file, which = 1, trust = getOption("rio.import.trust", default = NULL), ...) {
    .check_trust(trust, format = "RDS")
    readRDS(file = file)
}

#' @export
.import.rio_rdata <- function(file, which = 1, envir = new.env(), trust = getOption("rio.import.trust", default = NULL), .return_everything = FALSE, ...) {
    .check_trust(trust, format = "RData")
    load(file = file, envir = envir)
    if (isTRUE(.return_everything)) {
        ## for import_list()
        return(as.list(envir))
    }
    if (missing(which)) {
        if (length(ls(envir)) > 1) {
          warning("Rdata file contains multiple objects. Returning first object.")
        }
      which <- 1
    }
    if (is.numeric(which)) {
      get(ls(envir)[which], envir)
    } else {
      get(ls(envir)[grep(which, ls(envir))[1]], envir)
    }
}

#' @export
.import.rio_rda <- .import.rio_rdata

#' @export
.import.rio_feather <- function(file, which = 1, ...) {
    .check_pkg_availability("arrow")
    .docall(arrow::read_feather, ..., args = list(file = file))
}

#' @export
.import.rio_fst <- function(file, which = 1, ...) {
    .check_pkg_availability("fst")
    .docall(fst::read.fst, ..., args = list(path = file))
}

#' @export
.import.rio_matlab <- function(file, which = 1, ...) {
    .check_pkg_availability("rmatio")
    rmatio::read.mat(filename = file)
}

#' @export
.import.rio_dta <- function(file, haven = lifecycle::deprecated(),
                            convert.factors = lifecycle::deprecated(), which = 1, ...) {
    if (lifecycle::is_present(haven) || lifecycle::is_present(convert.factors)) {
        lifecycle::deprecate_warn(when = "0.5.31", what = "import(haven)", details = "dta will always be read by `haven`. The parameter `haven` will be dropped in v2.0.0.")
    }
    standardize_attributes(.docall(haven::read_dta, ..., args = list(file = file)))
}

#' @export
.import.rio_dbf <- function(file, which = 1, as.is = TRUE, ...) {
    .docall(foreign::read.dbf, ..., args = list(file = file, as.is = as.is))
}

#' @export
.import.rio_dif <- function(file, which = 1, ...) {
    .docall(utils::read.DIF, ..., args = list(file = file))
}

#' @export
.import.rio_sav <- function(file, which = 1, haven = lifecycle::deprecated(), to.data.frame = lifecycle::deprecated(), use.value.labels = lifecycle::deprecated(), ...) {
    if (lifecycle::is_present(haven) || lifecycle::is_present(to.data.frame) || lifecycle::is_present(use.value.labels)) {
        lifecycle::deprecate_warn(when = "0.5.31", what = "import(haven)", details = "sav will always be read by `haven`. The parameter `haven` will be dropped in v2.0.0.")
    }
    standardize_attributes(.docall(haven::read_sav, ..., args = list(file = file)))
}

#' @export
.import.rio_zsav <- function(file, which = 1, ...) {
    standardize_attributes(.docall(haven::read_sav, ..., args = list(file = file)))
}

#' @export
.import.rio_spss <- function(file, which = 1, ...) {
    standardize_attributes(.docall(haven::read_por, ..., args = list(file = file)))
}

#' @export
.import.rio_sas7bdat <- function(file, which = 1, column.labels = FALSE, ...) {
    standardize_attributes(.docall(haven::read_sas, ..., args = list(data_file = file)))
}

#' @export
.import.rio_xpt <- function(file, which = 1, haven = lifecycle::deprecated(), ...) {
    if (lifecycle::is_present(haven)) {
        lifecycle::deprecate_warn(when = "0.5.31", what = "import(haven)", details = "xpt will always be read by `haven`. The parameter `haven` will be dropped in v2.0.0.")
    }
    standardize_attributes(.docall(haven::read_xpt, ..., args = list(file = file)))
}

#' @export
.import.rio_mtp <- function(file, which = 1, ...) {
    .docall(foreign::read.mtp, ..., args = list(file = file))
}

#' @export
.import.rio_syd <- function(file, which = 1, ...) {
    .docall(foreign::read.systat, ..., args = list(file = file, to.data.frame = TRUE))
}

#' @export
.import.rio_json <- function(file, which = 1, ...) {
    .check_pkg_availability("jsonlite")
    .docall(jsonlite::fromJSON, ..., args = list(txt = file))
}

#' @export
.import.rio_rec <- function(file, which = 1, ...) {
    .docall(foreign::read.epiinfo, ..., args = list(file = file))
}

#' @export
.import.rio_arff <- function(file, which = 1, ...) {
    .docall(foreign::read.arff, ..., args = list(file = file))
}

#' @export
.import.rio_xls <- function(file, which = 1, header = TRUE, ...) {
    .remap_tidy_convention(readxl::read_xls, file = file, which = which, header = header, ...)
}

#' @export
.import.rio_xlsx <- function(file, which = 1, header = TRUE, readxl = lifecycle::deprecated(), ...) {
    if (lifecycle::is_present(readxl)) {
        lifecycle::deprecate_warn(
            when = "0.5.31",
            what = "import(readxl)",
            details = "xlsx will always be read by `readxl`. The parameter `readxl` will be dropped in v2.0.0."
        )
    }
    .remap_tidy_convention(readxl::read_xlsx, file = file, which = which, header = header, ...)
}

#' @export
.import.rio_fortran <- function(file, which = 1, style, ...) {
    if (missing(style)) {
        stop("Import of Fortran format data requires a 'style' argument. See ? utils::read.fortran().")
    }
    .docall(utils::read.fortran, ..., args = list(file = file, format = style))
}

#' @export
.import.rio_ods <- function(file, which = 1, header = TRUE, ...) {
    .check_pkg_availability("readODS")
    .remap_tidy_convention(readODS::read_ods, file = file, which = which, header = header, ...)
}

#' @export
.import.rio_fods <- function(file, which = 1, header = TRUE, ...) {
    .check_pkg_availability("readODS")
    .remap_tidy_convention(readODS::read_fods, file = file, which = which, header = header, ...)
}

#' @export
.import.rio_xml <- function(file, which = 1, stringsAsFactors = FALSE, ...) {
    .check_pkg_availability("xml2")
    x <- xml2::as_list(xml2::read_xml(unclass(file)))[[1L]]
    d <- do.call("rbind", c(lapply(x, unlist)))
    row.names(d) <- seq_len(nrow(d))
    d <- as.data.frame(d, stringsAsFactors = stringsAsFactors)
    tc2 <- function(x) {
        out <- utils::type.convert(x, as.is = FALSE)
        if (is.factor(out)) {
            x
        } else {
            out
        }
    }
    if (!isTRUE(stringsAsFactors)) {
        d[] <- lapply(d, tc2)
    } else {
        d[] <- lapply(d, utils::type.convert)
    }
    d
}

# This is a helper function for .import.rio_html
extract_html_row <- function(x, empty_value) {
    ## Both <th> and <td> are valid for table data, and <th> may be used when
    ## there is an accented element (e.g. the first row of the table)
    to_extract <- x[names(x) %in% c("th", "td")]
    ## Insert a value into cells that eventually will become empty cells (or they
    ## will be dropped and the table will not be generated).  Note that this more
    ## complex code for finding the length is required because of html like
    ## <td><br/></td>
    unlist_length <- vapply(lapply(to_extract, unlist), length, integer(1))
    to_extract[unlist_length == 0] <- list(empty_value)
    unlist(to_extract)
}

#' @export
.import.rio_html <- function(file, which = 1, stringsAsFactors = FALSE, ..., empty_value = "") {
    # find all tables
    tables <- xml2::xml_find_all(xml2::read_html(unclass(file)), ".//table")
    if (which > length(tables)) {
        stop(paste0("Requested table exceeds number of tables found in file (", length(tables), ")!"))
    }
    x <- xml2::as_list(tables[[which]])
    if ("tbody" %in% names(x)) {
        # Note that "tbody" may be specified multiple times in a valid html table
        x <- unlist(x[names(x) == "tbody"], recursive = FALSE)
    }
    # loop row-wise over the table and then rbind()
    ## check for table header to use as column names
    col_names <- NULL
    if ("th" %in% names(x[[1]])) {
        col_names <- extract_html_row(x[[1]], empty_value = empty_value)
        # Drop the first row since column names have already been extracted from it.
        x <- x[-1]
    }
    out <- do.call("rbind", lapply(x, extract_html_row, empty_value = empty_value))
    colnames(out) <-
        if (is.null(col_names)) {
            paste0("V", seq_len(ncol(out)))
        } else {
            col_names
        }
    out <- as.data.frame(out, ..., stringsAsFactors = stringsAsFactors)
    # set row names
    rownames(out) <- seq_len(nrow(out))
    # type.convert() to numeric, etc.
    out[] <- lapply(out, utils::type.convert, as.is = TRUE)
    out
}

#' @export
.import.rio_yml <- function(file, which = 1, stringsAsFactors = FALSE, ...) {
    .check_pkg_availability("yaml")
    as.data.frame(.docall(yaml::read_yaml, ..., args = list(file = file)), stringsAsFactors = stringsAsFactors)
}

#' @export
.import.rio_eviews <- function(file, which = 1, ...) {
    .check_pkg_availability("hexView")
    .docall(hexView::readEViews, ..., args = list(filename = file))
}

#' @export
.import.rio_clipboard <- function(file = "clipboard", which = 1, header = TRUE, sep = "\t", ...) {
    .check_pkg_availability("clipr")
    .docall(clipr::read_clip_tbl, ..., args = list(x = clipr::read_clip(), header = header, sep = sep))
}

#' @export
.import.rio_pzfx <- function(file, which = 1, ...) {
    .check_pkg_availability("pzfx")
    dots <- list(...)
    if ("path" %in% names(dots)) {
        dots[["path"]] <- NULL
    }
    if ("table" %in% names(dots)) {
        which <- dots[["table"]]
        dots[["table"]] <- NULL
    }
    .docall(pzfx::read_pzfx, args = c(dots, list(path = file, table = which)))
}

#' @export
.import.rio_parquet <- function(file, which = 1, ...) {
    .check_pkg_availability("arrow")
    .docall(arrow::read_parquet, ..., args = list(file = file, as_data_frame = TRUE))
}

#' @export
.import.rio_qs <- function(file, which = 1, ...) {
    .check_pkg_availability("qs")
    .docall(qs::qread, ..., args = list(file = file))
}
