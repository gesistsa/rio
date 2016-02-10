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

.export.rio_csvy <- function(file, x, ...) {
    # write yaml
    a <- attributes(x)
    a <- a[!names(a) %in% "row.names"]
    y <- paste0("---\n", as.yaml(a), "---\n")
    cat(y, file = file)
    
    # append CSV
    .export.rio_csv(file = file, x = x, append = TRUE, ...)
}

.export.rio_psv <- function(file, x, ...){
    export_delim(x = x, file = file, sep = "|", ...)
}

.export.rio_fwf <- function(file, x, sep = "", row.names = FALSE, quote = FALSE, col.names = FALSE, digits = getOption("digits", 7), ...){
    dat <- lapply(x, function(col) {
        if (is.character(col)) {
            col <- as.numeric(as.factor(col))
        } else if(is.factor(col)) {
            col <- as.numeric(col)
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
    dict <- paste0(names(n), ":\t", c(1, cumsum(n)+1), "-", cumsum(n), "\n")
    message("Columns:\n", paste0(dict[-length(dict)], collapse = ""))
    if(sep == "")
        message('Read in with `import("', file, '", widths = c(', paste0(n, collapse = ","), '))`\n')
    write.table(dat, file = file, row.names = row.names, sep = sep, quote = quote,
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

export <- function(x, file, format, ...) {
    if (missing(file) & missing(format)) {
        stop("Must specify 'file' and/or 'format'")
    } else if (!missing(file) & !missing(format)) {
        fmt <- tolower(format)
    } else if (!missing(file) & missing(format)) {
        fmt <- get_ext(file)
    } else if (!missing(format)) {
        fmt <- get_type(format)
        file <- paste0(as.character(substitute(x)), ".", fmt)
    }
    if (!is.data.frame(x) & !is.matrix(x)) {
        stop("`x` is not a data.frame or matrix")
    } else if (is.matrix(x)) {
        x <- as.data.frame(x)
    }
    stop_for_export(fmt)
    
    class(file) <- paste0("rio_", fmt)
    .export(file = file, x = x, ...)
  
    invisible(file)
}
