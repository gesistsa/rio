import_delim <- function(file, which = 1, fread = TRUE, sep = "auto", sep2 = "auto", header = "auto", stringsAsFactors = FALSE, data.table = FALSE, ...) {
  if (fread) {
    fread(input = file, sep = sep, sep2 = sep2, header = header, stringsAsFactors = stringsAsFactors, data.table = data.table, ...)
  } else {
    if (missing(sep) || is.null(sep) || sep == "auto") {
      sep <- "\t"
    }
    if (missing(header) || is.null(header) || header == "auto") {
      header <- TRUE
    }
    if (missing(sep2) || is.null(sep2) || sep2 == "auto") {
      sep2 <- "."
    }
    read.table(file = file, sep = sep, dec = sep2, header = header, stringsAsFactors = stringsAsFactors, ...)
  }
}

.import.rio_tsv <- function(file, sep, which = 1, fread = TRUE, ...){
  import_delim(file = file, sep = if (missing(sep)) "auto" else sep, fread = fread, ...)
}

.import.rio_txt <- function(file, sep, which = 1, fread = TRUE, ...){
  import_delim(file = file, sep = if (missing(sep)) "auto" else sep, fread = fread, ...)
}

.import.rio_csv <- function(file, sep, which = 1, fread = TRUE, ...){
  import_delim(file = file, sep = if (missing(sep)) "auto" else sep, fread = fread, ...)
}

.import.rio_csv2 <- function(file, sep, which = 1, fread = TRUE, ...){
  import_delim(file = file, sep = if (missing(sep)) "auto" else sep, fread = fread, ...)
}

.import.rio_psv <- function(file, sep, which = 1, fread = TRUE, ...){
  import_delim(file = file, sep = if (missing(sep)) "auto" else sep, fread = fread, ...)
}

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

.import.rio_r <- function(file, which = 1, ...){
  dget(file = file, ...)
}

.import.rio_rds <- function(file, which = 1, ...){
  readRDS(file = file, ...)
}

.import.rio_csvy <- function(file, which = 1, ...) {
    read_csvy(file = file, ...)
}

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

.import.rio_feather <- function(file, which = 1, ...){
    read_feather(path = file)
}

.import.rio_dta <- function(file, haven = TRUE, 
                            convert.dates = TRUE, 
                            convert.factors = FALSE, 
                            missing.type = FALSE, ...) {
  if (haven) {
    a <- list(...)
    if (length(a)) {
      warning("File imported using haven. Arguments to '...' ignored.")
    }
    convert_attributes(read_dta(path = file))
  } else {
    out <- read.dta(file = file, 
                    convert.dates = convert.dates, 
                    convert.factors = convert.factors, 
                    missing.type = missing.type, ...)
    attr(out, "expansion.fields") <- NULL
    attr(out, "time.stamp") <- NULL
    convert_attributes(out)
  }
}

.import.rio_dbf <- function(file, which = 1, ...){
  read.dbf(file = file, ...)
}

.import.rio_dif <- function(file, which = 1, ...){
  read.DIF(file = file, ...)
}

.import.rio_sav <- function(file, which = 1, haven = TRUE, to.data.frame = TRUE, use.value.labels = FALSE, ...) {
  if (haven) {
    convert_attributes(read_sav(path = file))
  } else {
    convert_attributes(read.spss(file = file, to.data.frame = to.data.frame, 
                                 use.value.labels = use.value.labels, ...))
  }
}

.import.rio_sas7bdat <- function(file, which = 1, column.labels = FALSE, ...) {
  convert_attributes(read_sas(b7dat = file, ...))
}

.import.rio_xpt <- function(file, which = 1, ...){
  read.xport(file = file, ...)
}

.import.rio_mtp <- function(file, which = 1, ...){
  read.mtp(file = file, ...)
}

.import.rio_syd <- function(file, which = 1, ...){
  read.systat(file = file, to.data.frame = TRUE, ...)
}

.import.rio_json <- function(file, which = 1, ...){
  fromJSON(txt = file, ...)
}

.import.rio_rec <- function(file, which = 1, ...){
  read.epiinfo(file = file, ...)
}

.import.rio_arff <- function(file, which = 1, ...){
  read.arff(file = file)
}

.import.rio_xls <- function(file, which = 1, ...){
  read_excel(path = file, ...)
}

.import.rio_xlsx <- function(file, which = 1, readxl = TRUE, ...) {
  a <- list(...)
  if ("sheet" %in% names(a)) {
        which <- a$sheet
  }
  if (readxl) {
    read_excel(path = file, sheet = which, ...)
  } else {
    read.xlsx(xlsxFile = file, sheet = which, ...)
  }
}

.import.rio_fortran <- function(file, which = 1, style, ...) {
    if (missing(style)) {
        stop("Import of Fortran format data requires a 'style' argument. See ? foreign::read.fortran().")
    }
    read.fortran(file = file, format = style, ...)
}

.import.rio_ods <- function(file, which = NULL, header = TRUE, ...) {
    a <- list(...)
    if ("sheet" %in% names(a)) {
        which <- a$sheet
    }
    handlingODSheader <- function(x) {
        colnames(x) <- x[1,]
        g <- x[2:nrow(x),]
        rownames(g) <- seq(from = 1, to = nrow(g))
        return(g)
    }
    if (getNrOfSheetsInODS(file) > 1 & is.null(which)) {
        msg <- paste0("There are ", getNrOfSheetsInODS(file), " sheets in the ODS file. Only the first sheet will be returned. Use sheet option from read.ods to select which sheet to import.")
        warning(msg)
        which <- 1
    } else if (getNrOfSheetsInODS(file) == 1) {
        which <- 1
    }
    res <- read.ods(file = file, sheet = which, ...)
    if (header & !is.data.frame(res)) {
        res <- lapply(res, handlingODSheader)
    }
    if (header & is.data.frame(res)) {
        res <- handlingODSheader(res)
    }
    return(res)
}

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

.import.rio_html <- function(file, which = 1, stringsAsFactors = FALSE, ...) {
    x <- as_list(read_html(unclass(file)))[["body"]][["table"]]
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
        colnames(out) <- paste0("V", 1:ncol(out))
    }
    row.names(out) <- 1:nrow(out)
    as.data.frame(out, ..., stringsAsFactors = stringsAsFactors)
}

.import.rio_yml <- function(file, which = 1, stringsAsFactors = FALSE, ...) {
  as.data.frame(yaml.load(file, ...), stringsAsFactors = stringsAsFactors)
}

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
