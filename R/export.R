export_delim <- function(file, x, sep = "\t", row.names = FALSE,
                         col.names = TRUE, ...) {
    write.table(x, file = file, sep = sep, row.names = row.names,
                col.names = col.names, ...)
}

.export.rio_txt <- function(file, x, ...){
    export_delim(x = x, file = file, ...)
}

.export.rio_tsv <- function(file, x, ...){
    export_delim(x = x, file = file, ...)
}


.export.rio_csv <- function(file, x, ...) {
    export_delim(x = x, file = file, sep = ",", dec = ".", ...)
}

.export.rio_csv2 <- function(file, x, ...){
    export_delim(x = x, file = file, sep =";", dec = ",", ...)
}

.export.rio_csvy <- function(file, x, comment_header = TRUE, ...) {
    # write yaml
    a <- attributes(x)
    a <- a[!names(a) %in% "row.names"]
    y <- paste0("#", paste0("---\n", as.yaml(a), "---\n"))
    cat(y, file = file)
    
    # append CSV
    .export.rio_csv(file = file, x = x, append = TRUE, ...)
}

.export.rio_psv <- function(file, x, ...){
    export_delim(x = x, file = file, sep = "|", ...)
}

.export.rio_fwf <- function(file, x, verbose = TRUE, sep = "", row.names = FALSE, quote = FALSE, col.names = FALSE, digits = getOption("digits", 7), ...){
    dat <- lapply(x, function(col) {
        if (is.character(col)) {
            col <- as.numeric(as.factor(col))
        } else if(is.factor(col)) {
            col <- as.integer(col)
        }
        if (is.integer(col)) {
            return(sprintf("%i",col))
        }
        if (is.numeric(col)) {
            s <- strsplit(as.character(col), ".", fixed = TRUE)
            m1 <- max(nchar(sapply(s, `[`, 1)), na.rm = TRUE)
            m2 <- max(nchar(sapply(s, `[`, 2)), na.rm = TRUE)
            if (!is.finite(m2)) {
                m2 <- digits
            }
            return(formatC(sprintf(fmt = paste0("%0.",m2,"f"), col), width = (m1+m2+1)))
        } else if(is.logical(col)) {
            return(sprintf("%i",col))
        }
    })
    dat <- do.call(cbind, dat)
    n <- nchar(dat[1,]) + c(rep(nchar(sep), ncol(dat)-1), 0)
    col_classes <- sapply(x, class)
    col_classes[col_classes == "factor"] <- "integer"
    dict <- cbind.data.frame(variable = names(n), 
                             class = col_classes, 
                             width = unname(n), 
                             columns = paste0(c(1, cumsum(n)+1)[-length(n)], "-", cumsum(n)),
                             stringsAsFactors = FALSE)
    if (verbose) {
        message("Columns:")
        print(dict)
        if (sep == "") {
            message('\nRead in with:\n',
                    'import("', file, '",\n',
                    '       widths = c(', paste0(n, collapse = ","), '),\n',
                    '       col.names = c("', paste0(names(n), collapse = '","'), '"),\n',
                    '       colClasses = c("', paste0(col_classes, collapse = '","') ,'"))\n')
        }
    }
    cat(paste0("#", capture.output(write.csv(dict, row.names = FALSE, quote = FALSE))), file = file, sep = "\n")
    write.table(dat, file = file, append = TRUE, row.names = row.names, sep = sep, quote = quote,
                col.names = col.names, ...)
}

.export.rio_r <- function(file, x, ...){
    dput(x, file = file, ...)
}

.export.rio_dump <- function(file, x, ...){
    dump(as.character(substitute(x)), file = file, ...)
}

.export.rio_rds <- function(file, x, ...){
    saveRDS(object = x, file = file, ...)
}

.export.rio_rdata <- function(file, x, ...){
    save(x = x, file = file, ...)
}

.export.rio_sav <- function(file, x, ...){
    write_sav(data = x, path = file, ...)
}

.export.rio_dta <- function(file, x, ...){
    write_dta(data = x, path = file, ...)
}

.export.rio_dbf <- function(file, x, ...){
    write.dbf(dataframe = x, file = file, ...)
}

.export.rio_json <- function(file, x, ...){
    cat(toJSON(x, ...), file = file)
}

.export.rio_arff <- function(file, x, ...){
    write.arff(x = x, file = file, ...)
}

.export.rio_xlsx <- function(file, x, ...){
    write.xlsx(x = x, file = file, ...)
}

.export.rio_xml <- function(file, x, ...) {
    root <- newXMLNode(as.character(substitute(x)))
    for (i in 1:nrow(x)) {
        obs <- newXMLNode("Observation", parent = root)
        rowname <- newXMLNode("rowname", parent = obs)
        xmlValue(rowname) <- rownames(x)[i]
        for (j in 1:ncol(x)) {
            obs_value <- newXMLNode(names(x)[j], parent = obs)
            xmlValue(obs_value) <- x[i,j]
        }
    }
    invisible(saveXML(doc = root, file = file, ...))
}

.export.rio_clipboard <- function(file, x, row.names = FALSE, col.names = TRUE, sep = "\t", ...) {
    if (Sys.info()["sysname"] == "Darwin") {
        clip <- pipe("pbcopy", "w")
        write.table(x, file = clip, sep = sep, row.names = row.names,
                    col.names = col.names, ...)
        close(clip)
    } else if (Sys.info()["sysname"] == "Windows") {
        write.table(x, file="clipboard", sep = sep, row.names = row.names,
                    col.names = col.names, ...)
    } else {
        stop("Writing to clipboard is not supported on your OS")
        return(NULL)
    }
}

.export.default <- function(file, x, ...){
  stop("Unrecognized file format")
}

.export <- function(file, x, ...){
  UseMethod(".export")
}

compress_out <- function(cfile, filename, type = c("zip", "tar", "gzip", "bzip2", "xz")) {
    type <- ext <- match.arg(type)
    if (ext %in% c("gzip", "bzip2", "xz")) {
        ext <- paste0("tar")
    }
    if (missing(cfile)) {
        cfile <- paste0(filename, ".", ext)
    }
    if (type == "zip") {
        o <- zip(cfile, files = filename)
    } else if (type == "tar") {
        o <- tar(cfile, files = filename)
    } else {
        o <- tar(cfile, files = filename, compression = type)
    }
    if (o != 0) {
        stop(sprintf("File compresion failed for %s!", cfile))
    }
    return(cfile)
}

find_compress <- function(f) {
    if (grepl("zip$", f)) {
        file <- sub("\\.zip$", "", f)
        compress <- "zip"
    } else if (grepl("tar\\.gz$", f)) {
        file <- sub("\\.tar\\.gz$", "", f)
        compress <- "gzip"
    } else if (grepl("tar$", f)) {
        file <- sub("\\.tar$", "", f)
        compress <- "tar"
    } else if (grepl("gz$", f)) {
        file <- sub("\\.gz$", "", f)
        compress <- "gzip"
    } else {
        file <- f
        compress <- NA_character_
    }
    return(list(file = file, compress = compress))
}

export <- function(x, file, format, ...) {
    if (missing(file) & missing(format)) {
        stop("Must specify 'file' and/or 'format'")
    } else if (!missing(file) & !missing(format)) {
        fmt <- tolower(format)
        cfile <- file
        f <- find_compress(file)
        file <- f$file
        compress <- f$compress
    } else if (!missing(file) & missing(format)) {
        cfile <- file
        f <- find_compress(file)
        file <- f$file
        compress <- f$compress
        fmt <- get_ext(file)
    } else if (!missing(format)) {
        fmt <- get_type(format)
        file <- paste0(as.character(substitute(x)), ".", fmt)
        compress <- NA_character_
    }
    
    if (!is.data.frame(x) & !is.matrix(x)) {
        stop("`x` is not a data.frame or matrix")
    } else if (is.matrix(x)) {
        x <- as.data.frame(x)
    }
    stop_for_export(fmt)
    
    class(file) <- paste0("rio_", fmt)
    .export(file = file, x = x, ...)
    
    if (!is.na(compress)) {
        cfile <- compress_out(cfile = cfile, filename = file, type = compress)
        unlink(file)
        return(invisible(cfile))
    }
    
    invisible(file)
}
