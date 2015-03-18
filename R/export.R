export.csv <- function(x, file, row.names = FALSE, ...) {
    write.csv(x, file = file, row.names = row.names, ...)
}

export.delim <- function(x, file, sep = "\t", row.names = FALSE,
                         col.names = TRUE, ...) {
    write.table(x, file = file, sep = sep, row.names = row.names,
                col.names = col.names, ...)
}

export.fwf <- function(x, file, sep = " ", row.names = FALSE, quote = FALSE,
                       col.names = FALSE, fmt.factor = "%0.7f", ...) {
    dat <- lapply(x, function(col) {
        if(is.character(col)) {
            col <- as.numeric(as.factor(col))
        } else if(is.factor(col)) {
            col <- as.numeric(col)
        }
        if(is.numeric(col)) {
            s <- strsplit(as.character(col), ".", fixed = TRUE)
            m1 <- max(nchar(sapply(s, `[`, 1)), na.rm = TRUE)
            m2 <- max(nchar(sapply(s, `[`, 2)), na.rm = TRUE)
            return(formatC(sprintf(fmt = paste0("%0.",m2,"f"), col), width = (m1+m2+1)))
        } else if(is.logical(col)) {
            return(sprintf("%i",col))
        }
    })
    dat <- do.call(cbind, dat)
    write.table(dat, file = file, row.names = row.names, sep = sep, quote = quote,
                col.names = col.names, ...)
}

export.xml <- function(x, file, ...) {
    root <- newXMLNode(as.character(substitute(x)))
    for(i in 1:nrow(x)){
        obs <- newXMLNode("Observation", parent = root)
        rowname <- newXMLNode("rowname", parent = obs)
        xmlValue(rowname) <- rownames(x)[i]
        for(j in 1:ncol(x)) {
            obs_value <- newXMLNode(names(x)[j], parent = obs)
            xmlValue(obs_value) <- x[i,j]
        }
    }
    invisible(saveXML(doc = root, file = file, ...))
}

export.clipboard <- function(x, row.names = FALSE, col.names = TRUE, ...) {
    if(Sys.info()["sysname"] == "Darwin") {
        clip <- pipe("pbcopy", "w")
        write.table(x, file = clip, sep="\t", row.names = row.names,
                    col.names = col.names, ...)
        close(clip)
    } else if(Sys.info()["sysname"] == "Windows") {
        write.table(x, file="clipboard", sep="\t", row.names = row.names,
                    col.names = col.names, ...)
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
         txt = export.delim(x, file = file, ...),
         tsv = export.delim(x, file = file, ...),
         csv = export.delim(x, file = file, sep = ",", dec = ".", ...),
         csv2 = export.delim(file = file, sep = ";", dec = ",", ...),
         psv = import.delim(file = file, sep = "|", ...),
         fwf = export.fwf(x, file = file, ...),
         r = dput(x, file = file, ...),
         dump = dump(as.character(substitute(x)), file = file, ...),
         clipboard = export.clipboard(x, ...),
         rds = saveRDS(x, file = file, ...),
         rdata = save(x, file = file, ...),
         sav = write_sav(data = x, path = file),
         dta = write_dta(data = x, path = file),
         dbf = write.dbf(dataframe = x, file = file, ...),
         json = cat(toJSON(x, ...), file = file),
         arff = write.arff(x = x, file = file, ...),
         xlsx = write.xlsx(x = x, file = file, ...),
         xml = export.xml(x, file = file, ...), 
         stop("Unrecognized file format")
         )
    invisible(file)
}
