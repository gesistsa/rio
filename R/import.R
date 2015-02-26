import.zip <- function(file, ...) {
    file_list <- unzip(file, list = TRUE)
    if(nrow(file_list) > 1)
        stop("Zip archive contains multiple files")
    else {
        unzip(file, exdir = tempdir())
        import(paste0(tempdir(),"/", file_list$Name), ...)
    }
}

import.tar <- function(file, ...) {
    file_list <- unzip(file, list = TRUE)
    if(nrow(file_list) > 1)
        stop("Tar archive contains multiple files")
    else {
        untar(file, exdir = tempdir())
        import(paste0(tempdir(),"/", file_list$Name), ...)
    }
}

import.csv <- function(file, header = TRUE, stringsAsFactors = FALSE, ...) {
    read.csv(file = file, header = header, stringsAsFactors = stringsAsFactors, ...)
}

import.tsv <- function(file, sep = "\t", header = TRUE, stringsAsFactors = FALSE, ...) {
    read.table(file = file, sep = sep, header = header, stringsAsFactors = stringsAsFactors, ...)
}

import.fwf <- function(file = file, header = FALSE, widths, stringsAsFactors = FALSE, ...) {
    if(missing(widths)) {
        stop("Import of fixed-width format data requires a 'widths' argument")
    }
    read.fwf(file = file, widths = widths, header = header, stringsAsFactors = stringsAsFactors, ...)
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
        temp_file <- tempfile(fileext = fmt)
        on.exit(unlink(temp_file))
        curl_download(file, temp_file, mode = "wb")
        file <- temp_file
    }
    x <- switch(fmt,
                r = dget(file = file),
                tsv = import.tsv(file = file, ...),
                txt = import.tsv(file = file, ...),
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
                zip = import.zip(file = file, ...),
                tar = import.tar(file = file, ...),
                stop("Unrecognized file format")
                )
    return(x)
}
