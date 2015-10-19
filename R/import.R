parse.zip <- function(file, which = 1, ...) {
    file_list <- unzip(file, list = TRUE)
    if(nrow(file_list) > 1)
        warning("Zip archive contains multiple files. Attempting first file.")
    else {
        unzip(file, exdir = tempdir())
        paste0(tempdir(),"/", file_list$Name[which])
    }
}

parse.tar <- function(file, which = 1, ...) {
    e <- file_ext(file)
    if(e == "tar") {
        file_list <- untar(file, list = TRUE)
        if(nrow(file_list) > 1)
            stop("Tar archive contains multiple files. Attempting first file.")
        untar(file, exdir = tempdir())
        paste0(tempdir(),"/", file_list$Name[which])
    } else if(e == "gz") {
        file_list <- untar(file, list = TRUE, compressed = TRUE)
        if(nrow(file_list) > 1)
            stop("Tar archive contains multiple files. Attempting first file.")
        untar(file, exdir = tempdir(), compressed = TRUE)
        paste0(tempdir(),"/", file_list$Name[which])
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

import.csvy <- function(file, ...) {
    # read in whole file
    f <- readLines(file)

    # identify yaml delimiters
    g <- grep("^---", f)
    if (length(g) > 2) {
    stop("More than 2 yaml delimiters found in file")
    } else if (length(g) == 1) {
    stop("Only one yaml delimiter found")
    } else if (length(g) == 0) {
    stop("No yaml delimiters found")
    }

    # extract yaml front matter and convert to R list
    y <- yaml.load(paste(f[(g[1]+1):(g[2]-1)], collapse = "\n"))
    y$fields

    # load the data
    import.delim(text = f[(g[2]+1):length(f)], ...)
}

import.fwf <- function(file = file, header = FALSE, widths, ...) {
    if(missing(widths)) {
        stop("Import of fixed-width format data requires a 'widths' argument. See `? read.fwf`.")
    }
    read.fwf2(file = file, widths = widths, header = header, ...)
}

import.fortran <- function(file, style, ...) {
    if(missing(style)) {
        stop("Import of Fortran format data requires a 'style' argument. See `? read.fortran`.")
    }
    read.fortran(file = file, format = style, ...)
}

import.dta <- function(file, haven = TRUE, column.labels = FALSE, ...) {
    if(haven) {
        a <- list(...)
        if(length(a))
            warning("File imported using haven. Arguments to '...' ignored.")
        if(column.labels) 
            return(read_dta(path = file))
        cleanup.haven(read_dta(path = file))
    } else {
        read.dta(file = file, ...)
    }
}

import.sav <- function(file, haven = TRUE, column.labels = FALSE, ...) {
    if(haven) {
        if(column.labels) 
            return(read_sav(path = file))
        cleanup.haven(read_sav(path = file))
    } else {
        read.spss(file = file, to.data.frame = TRUE, ...)
    }
}

import.por <- function(file, column.labels = FALSE, ...) {
    if(column.labels) 
        return(read_por(path = file))
    cleanup.haven(read_por(path = file))
}

import.sas <- function(file, column.labels = FALSE, ...) {
    if(column.labels) 
        return(read_sas(b7dat = file, ...))
    cleanup.haven(read_sas(b7dat = file, ...))
}

import.rdata <- function(file, which = 1, ...) {
    e <- new.env()
    load(file = file, envir = e, ...)
    get(ls(e)[which], e)
}

import.xlsx <- function(file = file, readxl = TRUE, ...) {
    if(readxl) {
        read_excel(path = file, ...)
    } else {
        read.xlsx(xlsxFile = file, ...)
    }
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

import.sql <- function(x, db_type, ...){
    switch(db_type,
           mysql = import.mysql(x, ...),
           postgresql = import.pg(x, ...),
           sqlite = import.sqlite(x, ...),
           stop("Unrecognized file format"))
}

import.mysql <- function(x, dbname, host, port, username, password, ...){
  db <- dplyr::src_mysql(dbname, host, port, username, password)
  result <- dplyr::collect(dplyr::tbl(db, from = x, ...))
  result
}

import.pg <- function(x, dbname, host, port, username, password, ...){
  db <- dplyr::src_postgres(dbname, host, port, username, password)
  result <- dplyr::collect(dplyr::tbl(db, from = x, ...))
  result
}

import.sqlite <- function(x, file, ...){
  db <- dplyr::src_sqlite(path = file)
  result <- dplyr::tbl(db, from = x, ...)
  result
}

import <- function(file, format, setclass, expandurl = TRUE, ...) {
    if(grepl("^http.*://", file)) {
        if(missing(format)) {
            if (isTRUE(expandurl)) {
                l_url <- expand_urls(file, warn = F, .progress = F)
                if (!is.na(l_url$expanded_url)) file <- l_url$expanded_url
        }
            fmt <- get_ext(file)
        } else {
            fmt <- get_type(format)
        }
        temp_file <- tempfile(fileext = paste0(".", fmt))
        on.exit(unlink(temp_file))
        u <- curl_fetch_memory(file)
        writeBin(object = u$content, con = temp_file)
        #parse_headers(u$headers) # placeholder
        file <- temp_file
    }
    if(grepl("zip$", file)) {
        file <- parse.zip(file)
    } else if(grepl("tar$", file) | grepl("gz$", file)) {
        file <- parse.tar(file)
    }
    if(missing(format)) {
        fmt <- get_ext(file)
    } else {
        fmt <- get_type(format)
    }
    x <- switch(fmt,
                r = dget(file = file),
                tsv = import.delim(file = file, sep = "\t", ...),
                txt = import.delim(file = file, sep = "\t", ...),
                fwf = import.fwf(file = file, ...),
                rds = readRDS(file = file, ...),
                csv = import.delim(file = file, sep = ",", ...),
                csv2 = import.delim(file = file, sep = ";", dec = ",", ...),
                csvy = import.csvy(file = file, ...),
                psv = import.delim(file = file, sep = "|", ...),
                rdata = import.rdata(file = file, ...),
                dta = import.dta(file = file, ...),
                dbf = read.dbf(file = file, ...),
                dif = read.DIF(file = file, ...),
                sav = import.sav(file = file, ...),
                por = import.por(file = file, ...),
                sas7bdat = import.sas(file = file, ...),
                xpt = read.xport(file = file),
                mtp = read.mtp(file = file, ...),
                syd = read.systat(file = file, to.data.frame = TRUE),
                json = fromJSON(txt = file, ...),
                rec = read.epiinfo(file = file, ...),
                arff = read.arff(file = file),
                xls = read_excel(path = file, ...),
                xlsx = import.xlsx(file = file, ...),
                fortran = import.fortran(file = file, ...),
                ods = import.ods(file = file, ...),
                xml = import.xml(file = file, ...),
                clipboard = import.clipboard(...),
                sql = import.sql(...),
                # unsupported formats
                tar = stop(stop_for_import(fmt)),
                zip = stop(stop_for_import(fmt)),
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
    }
    
    a <- list(...)
    if("data.table" %in% names(a) && isTRUE(a[["data.table"]])){
        setclass <- "data.table"
    }
    return(set_class(x, class = setclass))
}
