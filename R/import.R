import.zip <- function(file, which = 1, ...) {
    file_list <- unzip(file, list = TRUE)
    if(nrow(file_list) > 1)
        warning("Zip archive contains multiple files. Attempting first file.")
    else {
        unzip(file, exdir = tempdir())
        import(paste0(tempdir(),"/", file_list$Name[which]), ...)
    }
}

import.tar <- function(file, which = 1, ...) {
    file_list <- unzip(file, list = TRUE)
    if(nrow(file_list) > 1)
        stop("Tar archive contains multiple files. Attempting first file.")
    else {
        untar(file, exdir = tempdir())
        import(paste0(tempdir(),"/", file_list$Name[which]), ...)
    }
}

import.delim <- function(file, fread = TRUE, sep = "auto", header = "auto", stringsAsFactors = FALSE, data.table = FALSE, ...) {
    if(fread) {
        fread(input = file, sep = sep, sep2 = "auto", header = header, stringsAsFactors = stringsAsFactors, data.table = data.table, ...)
    } else {
        if(missing(sep) || is.null(sep) || sep == "auto")
            sep <- "\t"
        if(missing(header) || is.null(header) || header == "auto")
            header <- TRUE
        read.table(file = file, sep = sep, header = header, stringsAsFactors = stringsAsFactors, ...)
    }
}

import.fwf <- function(file = file, header = FALSE, widths, stringsAsFactors = FALSE, ...) {
    if(missing(widths)) {
        stop("Import of fixed-width format data requires a 'widths' argument. See `? read.fwf`.")
    }
    read.fwf(file = file, widths = widths, header = header, stringsAsFactors = stringsAsFactors, ...)
}

import.fortran <- function(file = file, style, ...) {
    if(missing(style)) {
        stop("Import of Fortran format data requires a 'style' argument. See `? read.fortran`.")
    }
    read.fortran(file = file, format = style, ...)
}

import.rdata <- function(file, which = 1, ...) {
    e <- new.env()
    load(file = file, envir = e, ...)
    get(ls(e)[which], e)
}

import.ods <- function(file, header = TRUE, sheet = NULL, ...) {
    handlingODSheader <- function(x) {
        colnames(x) <- x[1,]
        g <- x[2:nrow(x),]
        rownames(g) <- seq(from = 1, to = nrow(g))
        return(g)
    }
    if (getNrOfSheetsInODS(file) > 1 & is.null(sheet)) {
        warning(paste0("There are ", getNrOfSheetsInODS(file), " sheets in the ODS file. Only the first sheet will be returned. Use sheet option from read.ods to select which sheet to import."))
        sheet <- 1
    } else if (getNrOfSheetsInODS(file) == 1) {
        sheet <- 1
    }
    res <- read.ods(file = file, sheet = sheet, ...)
    if (header & !is.data.frame(res)) {
        res <- lapply(res, handlingODSheader)
    }
    if (header & is.data.frame(res)) {
        res <- handlingODSheader(res)
    }
    return(res)
}

import.xml <- function(file, colClasses = NULL, homogeneous = NA, collectNames = TRUE,
                       stringsAsFactors = FALSE, ...) {
    xmlToDataFrame(doc = xmlParse(file, ...), colClasses = colClasses, homogeneous = homogeneous,
                   collectNames = collectNames, stringsAsFactors = stringsAsFactors)
}

import.clipboard <- function(header = TRUE, sep = "\t", ...) {
    if(Sys.info()["sysname"] == "Darwin") {
        clip <- pipe("pbpaste")
        read.table(file = clip, sep = sep, ...)
        close(clip)
    } else if(Sys.info()["sysname"] == "Windows") {
        read.table(file = "clipboard", sep = sep, header = header, ...)
    } else {
        stop("Reading from clipboard is not supported on your OS")
    }
}

import <- function(file, format, setclass, ...) {
    if(missing(format))
        fmt <- get_ext(file)
    else
        fmt <- tolower(format)
    if(grepl("^http.*://", file)) {
        temp_file <- tempfile(fileext = fmt)
        on.exit(unlink(temp_file))
        curl_download(file, temp_file, mode = "wb")
        file <- temp_file
    }
    x <- switch(fmt,
                r = dget(file = file),
                tsv = import.delim(file = file, sep = "\t", ...),
                txt = import.delim(file = file, sep = "\t", ...),
                fwf = import.fwf(file = file, ...),
                rds = readRDS(file = file, ...),
                csv = import.delim(file = file, sep = ",", ...),
                csv2 = import.delim(file = file, sep = ";", dec = ",", ...),
                psv = import.delim(file = file, sep = "|", ...),
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
                json = fromJSON(txt = file, ...),
                rec = read.epiinfo(file = file, ...),
                arff = read.arff(file = file),
                xls = read_excel(path = file, ...),
                xlsx = read_excel(path = file, ...),
                fortran = import.fortran(file = file, ...),
                zip = import.zip(file = file, ...),
                tar = import.tar(file = file, ...),
                ods = import.ods(file = file, ...),
                xml = import.xml(file = file, ...),
                clipboard = import.clipboard(...),
                # unsupported formats
                gnumeric = stop(stop_for_import(fmt)),
                jpg = stop(stop_for_import(fmt)),
                png = stop(stop_for_import(fmt)),
                bmp = stop(stop_for_import(fmt)),
                tiff = stop(stop_for_import(fmt)),
                sss = stop(stop_for_import(fmt)),
                sdmx = stop(stop_for_import(fmt)),
                matlab = stop(stop_for_import(fmt)),
                gexf = stop(stop_for_import(fmt)),
                npy = stop(stop_for_import(fmt)),
                # unrecognized format
                stop("Unrecognized file format")
                )
    if(missing(setclass)) {
        return(set_class(x))
    } else {
        a <- list(...)
        if("data.table" %in% names(a) && isTRUE(a[["data.table"]]))
            setclass <- "data.table"
        return(set_class(x, class = setclass))
    }
}
