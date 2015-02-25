import.csv <- function(file, header = TRUE, stringsAsFactors = FALSE, ...) {
    read.csv(file = file, header = header, stringsAsFactors = FALSE, ...)
}

import.tsv <- function(file, sep = "\t", header = TRUE, ...) {
    read.table(file = file, sep = sep, header = header, stringsAsFactors = FALSE, ...)
}

import.fwf <- function(file = file, header = TRUE, widths, ...) {
    if(missing(widths)) {
        stop("Import of fixed-width format data requires a 'widths' argument")
    }
    read.fwf(file = file, widths = widths, stringsAsFactors = FALSE, ...)
}

import.fortran <- function(file = file, style, ...) {
    if(missing(style)) {
        stop("Import of Fortran format data requires a 'style' argument. See 'format' in read.fortran")
    }
    read.fortran(file = file, format = style, ...)
}

import.xlsx <- function(file = file, header = TRUE, ...) {
    read.xlsx(xlsxFile = file, colNames = header, ...)
}

import.rdata <- function(file, ...) {
    e <- new.env()
    load(file = file, envir = e, ...)
    get(ls(e)[1], e) # return first object from a .Rdata
}

import <- function(file, format, ...) {
    if(missing(format))
        fmt <- get_ext(file)
    else
        fmt <- tolower(format)
    if(grepl("^https://", file)) {
        temp_file <- tempfile(fileext = format)
        on.exit(unlink(temp_file))
        curl_download(file, temp_file, mode = "wb")
        file <- temp_file
    }
    x <- switch(fmt,
                tsv = import.tsv(file = file, ...),
                fwf = import.fwf(file = file, ...),
                rds = readRDS(file = file, ...),
                csv = import.csv(file = file, ...),
                rdata = import.rdata(file = file, ...),
                dta = read_dta(path = file),
                dbf = read.dbf(file = file, ...),
                dif = read.DIF(file = file, ...),
                sav = read_sav(path = file),
                por = read_por(path = file),
                sas7bdat = read_sas(b7dat = file, ...),
                xpt = read.xport(file = file),
                mtp = read.mtp(file = file, ...),
                syd = read.systat(file = file, to.data.frame = TRUE),
                json = fromJSON(file = file, ...),
                rec = read.epiinfo(file = file, ...),
                arff = read.arff(file = file),
                xlsx = import.xlsx(file = file, ...),
                fortran = import.fortran(file = file, ...),
                stop("Unrecognized file format")
                )
    return(x)
}
