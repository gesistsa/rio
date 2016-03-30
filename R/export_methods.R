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
    a <- a[!names(a) %in% c("names", "row.names")]
    
    a$fields <- list()
    for (i in seq_along(x)) {
        a$fields[[i]] <- list()
        a$fields[[i]][1] <- names(x)[i]
        a$fields[[i]][2] <- class(x[[i]])
        atmp <- attributes(x[[i]])
        atmp$class <- NULL
        a$fields[[i]] <- c(a$fields[[i]], unname(atmp))
        names(a$fields[[i]]) <- c("name", "class", names(atmp))
        if ("labels" %in% names(a$fields[[i]])) {
            a$fields[[i]][["labels"]] <- 
              setNames(as.list(unname(atmp$labels)), names(atmp$labels))
        }
        rm(atmp)
    }
    
    y <- paste0("---\n", as.yaml(a), "---\n")
    
    if (isTRUE(comment_header)){
      m <- readLines(textConnection(y))
      y <- paste0("#", m[-length(m)],collapse = "\n")
      y <- c(y, "\n")
    }
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
            message(paste0('\nRead in with:\n',
                    'import("', file, '",\n',
                    '       widths = c(', paste0(n, collapse = ","), '),\n',
                    '       col.names = c("', paste0(names(n), collapse = '","'), '"),\n',
                    '       colClasses = c("', paste0(col_classes, collapse = '","') ,'"))\n'), domain = NA)
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

.export.rio_feather <- function(file, x, ...){
    write_feather(x = x, path = file)
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
    wrap <- function(value, tag) {
        paste0("<", tag, ">", value, "</", tag, ">")
    }
    root <- ""
    for (i in 1:nrow(x)) {
        out <- ""
        for (j in seq_along(x)) {
            out <- paste0(out, wrap(x[i,j], names(x)[j]))
        }
        root <- paste0(root, wrap(out, "Observation"))
    }
    cat(wrap(root, as.character(substitute(x))), file = file, ...)
}

.export.rio_yml <- function(file, x, ...) {
  cat(as.yaml(x, ...), file = file)
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
        stop("Writing to clipboard is not supported on your OS.")
        return(NULL)
    }
}

