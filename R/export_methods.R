#' @importFrom data.table fwrite
#' @importFrom utils write.table
export_delim <- function(file, x, fwrite = TRUE, sep = "\t", row.names = FALSE,
                         col.names = TRUE, ...) {
    if (fwrite) {
        fwrite(x, file = file, sep = sep, col.name = col.names,
               row.names = row.names, ...)
    } else {
        write.table(x, file = file, sep = sep, row.names = row.names,
                    col.names = col.names, ...)
    }
}

#' @export
.export.rio_txt <- function(file, x, ...) {
    export_delim(x = x, file = file, ...)
}

#' @export
.export.rio_tsv <- function(file, x, ...) {
    export_delim(x = x, file = file, ...)
}

#' @export
.export.rio_csv <- function(file, x, ...) {
    export_delim(x = x, file = file, sep = ",", dec = ".", ...)
}

#' @export
.export.rio_csv2 <- function(file, x, ...) {
    export_delim(x = x, file = file, sep =";", dec = ",", ...)
}

#' @importFrom csvy write_csvy
#' @export
.export.rio_csvy <- function(file, x, ...) {
    write_csvy(file = file, x = x, ...)
}

#' @export
.export.rio_psv <- function(file, x, ...) {
    export_delim(x = x, file = file, sep = "|", ...)
}

#' @importFrom utils capture.output write.csv
#' @export
.export.rio_fwf <- function(file, x, verbose = TRUE, sep = "", row.names = FALSE, quote = FALSE, col.names = FALSE, digits = getOption("digits", 7), ...) {
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

#' @export
.export.rio_r <- function(file, x, ...) {
    dput(x, file = file, ...)
}

#' @export
.export.rio_dump <- function(file, x, ...) {
    dump(as.character(substitute(x)), file = file, ...)
}

#' @export
.export.rio_rds <- function(file, x, ...) {
    saveRDS(object = x, file = file, ...)
}

#' @export
.export.rio_rdata <- function(file, x, ...) {
    save(x, file = file, ...)
}

#' @export
.export.rio_rda <- .export.rio_rdata

#' @export
.export.rio_feather <- function(file, x, ...) {
    requireNamespace("feather")
    feather::write_feather(x = x, path = file)
}

#' @importFrom haven write_sav
#' @export
.export.rio_sav <- function(file, x, ...) {
    write_sav(data = x, path = file, ...)
}

#' @importFrom haven write_dta
#' @export
.export.rio_dta <- function(file, x, ...) {
    write_dta(data = x, path = file, ...)
}

#' @importFrom haven write_sas
#' @export
.export.rio_sas7bdat <- function(file, x, ...) {
    write_sas(data = x, path = file, ...)
}

#' @importFrom foreign write.dbf
#' @export
.export.rio_dbf <- function(file, x, ...) {
    write.dbf(dataframe = x, file = file, ...)
}

#' @importFrom jsonlite toJSON
#' @export
.export.rio_json <- function(file, x, ...) {
    cat(toJSON(x, ...), file = file)
}

#' @importFrom foreign write.arff
#' @export
.export.rio_arff <- function(file, x, ...) {
    write.arff(x = x, file = file, ...)
}

#' @importFrom openxlsx write.xlsx
#' @export
.export.rio_xlsx <- function(file, x, ...) {
    write.xlsx(x = x, file = file, ...)
}

#' @importFrom xml2 read_html read_xml xml_children xml_add_child write_xml
#' @export
.export.rio_html <- function(file, x, ...) {
    x[] <- lapply(x, as.character)
    out <- character(nrow(x))
    html <- read_html("<!doctype html><html><head>\n<title>R Exported Data</title>\n</head><body>\n<table></table>\n</body>\n</html>")
    tab <- xml_children(xml_children(html)[[2]])[[1]]
    # add header row
    invisible(xml_add_child(tab, read_xml(paste0(twrap(paste0(twrap(names(x), "th"), collapse = ""), "tr"), "\n"))))
    # add data
    for (i in seq_len(nrow(x))) {
        xml_add_child(tab, read_xml(paste0(twrap(paste0(twrap(unlist(x[i, , drop = TRUE]), "td"), collapse = ""), "tr"), "\n")))
    }
    write_xml(html, file = file, ...)
}

#' @importFrom xml2 read_xml xml_children xml_add_child xml_add_sibling xml_attr<- write_xml
#' @export
.export.rio_xml <- function(file, x, ...) {
    root <- ""
    xml <- read_xml(paste0("<",as.character(substitute(x)),">\n</",as.character(substitute(x)),">\n"))
    att <- attributes(x)[!names(attributes(x)) %in% c("names", "row.names", "class")]
    for (a in seq_along(att)) {
        xml_attr(xml, names(att)[a]) <- att[[a]]
    }
    # add data
    for (i in seq_len(nrow(x))) {
        thisrow <- xml_add_child(xml, "Observation")
        xml_attr(thisrow, "row.name") <- row.names(x)[i]
        for (j in seq_along(x)) {
            xml_add_child(thisrow, read_xml(paste0(twrap(x[i, j, drop = TRUE], names(x)[j]), "\n")))
        }
    }

    write_xml(xml, file = file, ...)
}

# @importFrom readODS write_ods
# @export
#.export.rio_ods <- function(file, x, which = 1, ...) {
#    write_ods(x = x, path = file, sheet = which, ...)
#}

#' @importFrom yaml as.yaml
#' @export
.export.rio_yml <- function(file, x, ...) {
  cat(as.yaml(x, ...), file = file)
}

#' @importFrom utils write.table
#' @export
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
