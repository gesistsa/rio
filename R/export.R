export.csv <- function(x, file, row.names = FALSE, ...) {
    write.csv(x, file = file, row.names = row.names, ...)
}

export.txt <- function(x, file, sep = "\t", row.names = FALSE, header = TRUE, ...) {
    write.table(x, file = file, sep = sep, row.names = row.names, col.names = header, ...)
}

export.clipboard <- function(x, ...) {
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
    } else if(!missing(format)) {
        fmt <- get_type(format)
        file <- paste0(as.character(substitute(x)), ".", fmt)
    } else if(!missing(file)) {
        format <- get_ext(file)
    }
    if (!is.data.frame(x) & !is.matrix(x)) {
        stop("x is not a data frame or matrix.")
    } else if (is.matrix(x)) {
        x <- as.data.frame(x)
    }
    switch(format,
         txt = export.txt(x, file = file, ...),
         tsv = export.txt(x, file = file, ...),
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
