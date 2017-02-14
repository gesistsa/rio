#' @importFrom data.table fread
import_delim <-
function(file, which = 1, fread = TRUE, sep = "auto", sep2 = "auto",
         header = "auto", stringsAsFactors = FALSE, data.table = FALSE, ...) {
    if (isTRUE(fread) & !inherits(file, "connection")) {
        fread(input = file, sep = sep, sep2 = sep2, header = header,
              stringsAsFactors = stringsAsFactors, data.table = data.table, ...)
    } else {
        if (inherits(file, "connection")) {
            message("data.table::fread() does not support reading from connections. Using utils::read.table() instead.")
        }
        dots <- list(...)
        dots[["file"]] <- file
        if (missing(sep) || is.null(sep) || sep == "auto") {
            if (inherits(file, "rio_csv")) {
                dots[["sep"]] <- ","
            } else if (inherits(file, "rio_csv2")) {
                dots[["sep"]] <- ";"
            } else if (inherits(file, "rio_psv")) {
                dots[["sep"]] <- "|"
            } else {
                dots[["sep"]] <- "\t"
            }
        }
        if (!"dec" %in% names(dots)) {
            if (missing(sep2) || is.null(sep2) || sep2 == "auto") {
                dots[["dec"]] <- "."
            } else {
                dots[["dec"]] <- sep2
            }
        }
        if (missing(header) || is.null(header) || header == "auto") {
            dots[["header"]] <- TRUE
        }
        dots[["stringsAsFactors"]] <- stringsAsFactors
        do.call("read.table", dots)
    }
}

#' @export
.import.rio_tsv <- function(file, sep, which = 1, fread = TRUE, ...) {
  import_delim(file = file, sep = if (missing(sep)) "auto" else sep, fread = fread, ...)
}

#' @export
.import.rio_txt <- function(file, sep, which = 1, fread = TRUE, ...) {
  import_delim(file = file, sep = if (missing(sep)) "auto" else sep, fread = fread, ...)
}

#' @export
.import.rio_csv <- function(file, sep, which = 1, fread = TRUE, ...) {
  import_delim(file = file, sep = if (missing(sep)) "auto" else sep, fread = fread, ...)
}

#' @export
.import.rio_csv2 <- function(file, sep, which = 1, fread = TRUE, ...) {
  import_delim(file = file, sep = if (missing(sep)) "auto" else sep, fread = fread, ...)
}

#' @export
.import.rio_psv <- function(file, sep, which = 1, fread = TRUE, ...) {
  import_delim(file = file, sep = if (missing(sep)) "auto" else sep, fread = fread, ...)
}

#' @importFrom utils read.fwf
#' @importFrom readr read_fwf fwf_empty fwf_widths fwf_positions
#' @export
.import.rio_fwf <- function(file, which = 1, widths, header = FALSE, col.names, readr = FALSE, progress = FALSE, ...) {
  if (missing(widths)) {
    stop("Import of fixed-width format data requires a 'widths' argument. See ? read.fwf().")
  }
  a <- list(...)
  if (readr) {
    if (is.null(widths)) {
      if (!missing(col.names)) {
        widths <- fwf_empty(file = file, col_names = col.names)
      } else {
        widths <- fwf_empty(file = file)
      }
      read_fwf(file = file, col_positions = widths, progress = progress, ...)
    } else if (is.numeric(widths)) {
      if (any(widths < 0)) {
        if (!"col_types" %in% names(a)) {
          col_types <- rep("?", length(widths))
          col_types[widths < 0] <- "?"
          col_types <- paste0(col_types, collapse = "")
        }
        if (!missing(col.names)) {
          widths <- fwf_widths(abs(widths), col_names = col.names)
        } else {
          widths <- fwf_widths(abs(widths))
        }
        read_fwf(file = file, col_positions = widths, col_types = col_types, progress = progress, ...)
      } else {
        if (!missing(col.names)) {
          widths <- fwf_widths(abs(widths), col_names = col.names)
        } else {
          widths <- fwf_widths(abs(widths))
        }
        read_fwf(file = file, col_positions = widths, progress = progress, ...)
      }
    } else if (is.list(widths)) {
      if (!c("begin", "end") %in% names(widths)) {
        if (!missing(col.names)) {
          widths <- fwf_widths(widths, col_names = col.names)
        } else {
          widths <- fwf_widths(widths)
        }
      }
      read_fwf(file = file, col_positions = widths, progress = progress, ...)
    }
  } else {
    if (!missing(col.names)) {
      read.fwf2(file = file, widths = widths, header = header, col.names = col.names, ...)
    } else {
      read.fwf2(file = file, widths = widths, header = header, ...)
    }
  }
}

#' @export
.import.rio_r <- function(file, which = 1, ...) {
  dget(file = file, ...)
}

#' @export
.import.rio_rds <- function(file, which = 1, ...) {
  readRDS(file = file, ...)
}

#' @importFrom csvy read_csvy
#' @export
.import.rio_csvy <- function(file, which = 1, ...) {
    read_csvy(file = file, ...)
}

#' @export
.import.rio_rdata <- function(file, which = 1, envir = new.env(), ...) {
  load(file = file, envir = envir, ...)
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
    requireNamespace("feather")
    feather::read_feather(path = file)
}

#' @importFrom foreign read.dta
#' @importFrom haven read_dta
#' @export
.import.rio_dta <- function(file, haven = TRUE,
                            convert.dates = TRUE,
                            convert.factors = FALSE,
                            missing.type = FALSE, ...) {
  if (haven) {
    a <- list(...)
    if (length(a)) {
      warning("File imported using haven. Arguments to '...' ignored.")
    }
    standardize_attributes(read_dta(file = file))
  } else {
    out <- read.dta(file = file,
                    convert.dates = convert.dates,
                    convert.factors = convert.factors,
                    missing.type = missing.type, ...)
    attr(out, "expansion.fields") <- NULL
    attr(out, "time.stamp") <- NULL
    standardize_attributes(out)
  }
}

#' @importFrom foreign read.dbf
#' @export
.import.rio_dbf <- function(file, which = 1, ...) {
  read.dbf(file = file, ...)
}

#' @importFrom utils read.DIF
#' @export
.import.rio_dif <- function(file, which = 1, ...) {
  read.DIF(file = file, ...)
}

#' @importFrom haven read_sav
#' @importFrom foreign read.spss
#' @export
.import.rio_sav <- function(file, which = 1, haven = TRUE, to.data.frame = TRUE, use.value.labels = FALSE, ...) {
  if (haven) {
    standardize_attributes(read_sav(file = file))
  } else {
    standardize_attributes(read.spss(file = file, to.data.frame = to.data.frame,
                                 use.value.labels = use.value.labels, ...))
  }
}

#' @importFrom haven read_por
#' @export
.import.rio_spss <- function(file, which = 1, ...) {
  standardize_attributes(read_por(file = file))
}

#' @importFrom haven read_sas
#' @export
.import.rio_sas7bdat <- function(file, which = 1, column.labels = FALSE, ...) {
  standardize_attributes(read_sas(data_file = file, ...))
}

#' @importFrom foreign read.xport
#' @export
.import.rio_xpt <- function(file, which = 1, ...) {
  read.xport(file = file, ...)
}

#' @importFrom foreign read.mtp
#' @export
.import.rio_mtp <- function(file, which = 1, ...) {
  read.mtp(file = file, ...)
}

#' @importFrom foreign read.systat
#' @export
.import.rio_syd <- function(file, which = 1, ...) {
  read.systat(file = file, to.data.frame = TRUE, ...)
}

#' @importFrom jsonlite fromJSON
#' @export
.import.rio_json <- function(file, which = 1, ...) {
  fromJSON(txt = file, ...)
}

#' @importFrom foreign read.epiinfo
#' @export
.import.rio_rec <- function(file, which = 1, ...) {
  read.epiinfo(file = file, ...)
}

#' @importFrom foreign read.arff
#' @export
.import.rio_arff <- function(file, which = 1, ...) {
  read.arff(file = file)
}

#' @importFrom readxl read_xls
#' @export
.import.rio_xls <- function(file, which = 1, ...) {

    Call <- match.call(expand.dots = TRUE)
    if ("which" %in% names(Call)) {
        Call$sheet <- Call$which
        Call$which <- NULL
    }

    Call$path <- file
    Call$file <- NULL
    Call$readxl <- NULL
    Call[[1L]] <- as.name("read_xls")
    eval.parent(Call)
}

#' @importFrom readxl read_xlsx
#' @importFrom openxlsx read.xlsx
#' @export
.import.rio_xlsx <- function(file, which = 1, readxl = TRUE, ...) {

    Call <- match.call(expand.dots = TRUE)
    if ("which" %in% names(Call)) {
        Call$sheet <- Call$which
        Call$which <- NULL
    }
    if (isTRUE(readxl)) {
        Call$path <- file
        Call[[1L]] <- as.name("read_xlsx")
    } else {
        Call$xlsxFile <- file
        Call[[1L]] <- as.name("read.xlsx")
    }
    Call$file <- NULL
    Call$readxl <- NULL
    eval.parent(Call)
}

#' @importFrom utils read.fortran
#' @export
.import.rio_fortran <- function(file, which = 1, style, ...) {
    if (missing(style)) {
        stop("Import of Fortran format data requires a 'style' argument. See ? utils::read.fortran().")
    }
    read.fortran(file = file, format = style, ...)
}

#' @importFrom readODS read_ods
#' @export
.import.rio_ods <- function(file, which = 1, header = TRUE, ...) {
    res <- read_ods(path = file, sheet = which, col_names = header, ...)
    return(res)
}

#' @importFrom xml2 read_xml as_list
#' @export
.import.rio_xml <- function(file, which = 1, stringsAsFactors = FALSE, ...) {
    x <- as_list(read_xml(unclass(file)))
    d <- do.call("rbind", c(lapply(x, unlist)))
    row.names(d) <- 1:nrow(d)
    d <- as.data.frame(d, stringsAsFactors = stringsAsFactors)
    tc2 <- function(x) {
        out <- type.convert(x)
        if (is.factor(out)) {
            x
        } else {
            out
        }
    }
    if (!stringsAsFactors) {
        d[] <- lapply(d, tc2)
    } else {
        d[] <- lapply(d, type.convert)
    }
    d
}

#' @importFrom xml2 read_html as_list xml_find_all
#' @export
.import.rio_html <- function(file, which = 1, stringsAsFactors = FALSE, ...) {
    tables <- xml_find_all(read_html(unclass(file)), ".//table")
    if (which > length(tables)) {
        stop(paste0("Requested table exceeds number of tables found in file (", length(tables),")!"))
    }
    x <- as_list(tables[[which]])
    if ("tbody" %in% names(x)) {
        x <- x[["tbody"]]
    }
    if ("th" %in% names(x[[1]])) {
        col_names <- unlist(x[[1]][names(x[[1]]) %in% "th"])
        out <- do.call("rbind", lapply(x[-1], function(y) {
            unlist(y[names(y) %in% "td"])
        }))
        colnames(out) <- col_names
    } else {
        out <- do.call("rbind", lapply(x, function(y) {
            unlist(y[names(y) %in% "td"])
        }))
        colnames(out) <- paste0("V", seq_len(ncol(out)))
    }
    row.names(out) <- 1:nrow(out)
    as.data.frame(out, ..., stringsAsFactors = stringsAsFactors)
}

#' @importFrom yaml yaml.load
#' @export
.import.rio_yml <- function(file, which = 1, stringsAsFactors = FALSE, ...) {
  as.data.frame(yaml.load(file, ...), stringsAsFactors = stringsAsFactors)
}

#' @importFrom utils read.table
#' @export
.import.rio_clipboard <- function(file = "clipboard", which = 1, header = TRUE, sep = "\t", ...) {
    if (Sys.info()["sysname"] == "Darwin") {
        clip <- pipe("pbpaste")
        read.table(file = clip, sep = sep, ...)
        close(clip)
    } else if(Sys.info()["sysname"] == "Windows") {
        read.table(file = file, sep = sep, header = header, ...)
    } else {
        stop("Reading from clipboard is not supported on your OS")
    }
}
