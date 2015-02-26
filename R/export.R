export.csv <- function(x, file, row.names = FALSE, ...) {
    write.csv(x, file = file, row.names = row.names, ...)
}

export.tsv <- function(x, file, sep = "\t", row.names = FALSE, header = TRUE, ...) {
    write.table(x, file = file, sep = sep, row.names = row.names, col.names = header, ...)
}

export.fwf <- function(x, file, sep = " ", row.names = FALSE, quote = FALSE, col.names = FALSE, 
                       fmt.numeric = "%0.7f", fmt.factor = "%", ...) {
    dat <- lapply(x, function(col) {
        if(is.numeric(col)) {
            return(sprintf(fmt = fmt.numeric, col))
        } else if(is.character(col)) {
            col <- as.numeric(as.factor(col))
            return(sprintf(fmt = paste0("%0", max(nchar(as.character(col))), "s"), col))
        } else if(is.factor(col)) {
            return(sprintf(fmt = fmt.factor, as.numeric(col)))
        } else if(is.logical(col)) {
            return(sprintf("%i",col))
        }
    })
    dat <- do.call(cbind, x)
    write.table(dat, row.names = row.names, sep = sep, quote = quote, col.names = col.names, ...)
}

export.clipboard <- function(x, row.names = FALSE, header = TRUE, ...) {
    if(Sys.info()["sysname"] == "Darwin") {
        clip <- pipe("pbcopy", "w")                                             
        write.table(x, file = clip, sep="\t", row.names = row.names, col.names = header, ...)
        close(clip)
    } else if(Sys.info()["sysname"] == "Windows") {
        write.table(x, file="clipboard", sep="\t", row.names = row.names, col.names = header, ...)
    }
}

export <- function(x, file, format, ...) {
    if(missing(file) & missing(format)) {
        stop("Must specify 'file' and/or 'format'")
    } else if(!missing(file) & !missing(format)) {
        fmt <- format
    } else if(!missing(file) & missing(format)) {
        fmt <- get_ext(file)
    } else if(!missing(format)) {
        fmt <- get_type(format)
        file <- paste0(as.character(substitute(x)), ".", fmt)
    } 
    if (!is.data.frame(x) & !is.matrix(x)) {
        stop("x is not a data frame or matrix.")
    } else if (is.matrix(x)) {
        x <- as.data.frame(x)
    }
    switch(fmt,
         r = dput(x, file = file, ...),
         dump = dump(as.character(substitute(x)), file = file, ...),
         txt = export.tsv(x, file = file, ...),
         tsv = export.tsv(x, file = file, ...),
         fwf = export.fwf(x, file = file, ...),
         clipboard = export.clipboard(x, ...),
         rds = saveRDS(x, file = file, ...),
         csv = export.csv(x, file = file, ...), 
         rdata = save(x, file = file, ...),
         sav = write_sav(data = x, path = file),
         dta = write_dta(data = x, path = file),
         dbf = write.dbf(dataframe = x, file = file, ...),
         json = cat(toJSON(x, ...), file = file),
         arff = write.arff(x = x, file = file, ...),
         xlsx = write.xlsx(x = x, file = file, ...),
         stop("Unrecognized file format")
         )
    invisible(file)
}
