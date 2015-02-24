import.txt <- function(file, sep = "\t", header = TRUE, ...) {
    read.table(file = file, sep = sep, header = header, ...)
}

import.rdata <- function(file, ...) {
    e <- new.env()
    load(file = file, envir = e, ...)
    get(ls(e)[1], e) # return first object from a .Rdata
}

import <- function(file = "", format = NULL, header = TRUE, ... ) {
    if(is.null(format))
        format <- .guess(file)
    x <- switch(format,
                txt = import.tsv(file = file, header = header, ...),
                tsv = import.tsv(file = file, header = header, ...),
                fwf = read.fwf(file = file, header = header, ...),
                rds = import.rds(file = file, ...),
                csv = read.csv(file = file, header = header, ...),
                rdata = readRDS(file = file, ...),
                dta = read_dta(path = file),
                dbf = read.dbf(file = file, ...),
                dif = read.DIF(file = file, ...),
                sav = read_sav(path = file),
                por = read_por(path = file),
                sas7bdat = read_sas(b7dat = file, ...),
                mtp = read.mtp(file=file, ...),
                syd = read.systat(file = file, to.data.frame = TRUE),
                json = fromJSON(file = file, ...),
                rec = read.epiinfo(file=file, ...),
                arff = read.arff(file = file),
                xpt = read.xport(file = file),
                xlsx = read.xlsx(xlsxFile = file, colNames = header, ...),
                stop("Unknown file format")
                )
    return(x)
}
