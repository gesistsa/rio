import <- function(file="", format=NULL, header=TRUE, ... ) {
    if(is.null(format))
        format <- .guess(file)
    x <- switch(format,
                txt = read.table(file=file, sep="\t", header=header, ...),
                tsv = read.table(file=file, sep="\t", header=header, ...),
                fwf = utils::read.fwf(file = file, header = header, ...),
                rds = readRDS(file=file, ...),
                csv = read.csv(file=file, header=header, ...),
                rdata = { e <- new.env(); load(file = file, envir = e, ...); get(ls(e)[1], e) }, # return first object from a .Rdata
                dta = haven::read_dta(path = file),
                dbf = foreign::read.dbf(file = file, ...),
                dif = utils::read.DIF(file = file, ...),
                sav = haven::read_sav(path = file),
                por = haven::read_por(path = file),
                sas7bdat = haven::read_sas(b7dat = file, ...),
                mtp = foreign::read.mtp(file=file, ...),
                syd = foreign::read.systat(file = file, to.data.frame = TRUE),
                json = jsonlite::fromJSON(file = file, ...),
                rec = foreign::read.epiinfo(file=file, ...),
                arff = foreign::read.arff(file = file),
                xpt = foreign::read.xport(file = file),
                xlsx = openxlsx::read.xlsx(xlsxFile = file, colNames = header, ...),
                stop("Unknown file format")
                )
    return(x)
}
