#' @importFrom data.table fwrite
#' @importFrom utils write.table
export_delim <- function(file, x, fwrite = TRUE, sep = "\t", row.names = FALSE,
                         col.names = TRUE, ...) {
    if (isTRUE(fwrite) & !inherits(file, "connection")) {
        fwrite(x, file = file, sep = sep, col.name = col.names,
               row.names = row.names, ...)
    } else {
        if (isTRUE(fwrite) & inherits(file, "connection")) {
            message("data.table::fwrite() does not support writing to connections. Using utils::write.table() instead.")
        }
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

#' @export
.export.rio_csvy <- function(file, x, ...) {
    requireNamespace("csvy", quietly = TRUE)
    csvy::write_csvy(file = file, x = x, ...)
}

#' @export
.export.rio_psv <- function(file, x, ...) {
    export_delim(x = x, file = file, sep = "|", ...)
}

#' @importFrom utils capture.output write.csv
#' @export
.export.rio_fwf <- function(file, x, verbose = getOption("verbose", FALSE), sep = "", row.names = FALSE, quote = FALSE, col.names = FALSE, digits = getOption("digits", 7), ...) {
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
    if (is.data.frame(x)) {
        return(save(x, file = file, ...))
    } else if (is.list(x)) {
        e <- as.environment(x)
        save(list = names(x), file = file, envir = e, ...)
    } else if (is.environment(x)) {
        save(list = ls(x), file = file, envir = x, ...)
    } else if (is.character(x)) {
        save(list = x, file = file, ...)
    } else {
        stop("'x' must be a data.frame, list, or environment")
    }
}

#' @export
.export.rio_rda <- .export.rio_rdata

#' @export
.export.rio_feather <- function(file, x, ...) {
    requireNamespace("feather", quietly = TRUE)
    feather::write_feather(x = x, path = file)
}

#' @export
.export.rio_fst <- function(file, x, ...) {
    requireNamespace("fst", quietly = TRUE)
    fst::write.fst(x = x, path = file, ...)
}

#' @export
.export.rio_matlab <- function(file, x, ...) {
    requireNamespace("rmatio", quietly = TRUE)
    rmatio::write.mat(object = x, filename = file, ...)
}

#' @importFrom haven write_sav
#' @export
.export.rio_sav <- function(file, x, ...) {
    x <- restore_labelled(x)
    write_sav(data = x, path = file, ...)
}

#' @importFrom haven write_dta
#' @export
.export.rio_dta <- function(file, x, ...) {
    x <- restore_labelled(x)
    write_dta(data = x, path = file, ...)
}

#' @importFrom haven write_sas
#' @export
.export.rio_sas7bdat <- function(file, x, ...) {
    x <- restore_labelled(x)
    write_sas(data = x, path = file, ...)
}

#' @importFrom foreign write.dbf
#' @export
.export.rio_dbf <- function(file, x, ...) {
    write.dbf(dataframe = x, file = file, ...)
}

#' @export
.export.rio_json <- function(file, x, ...) {
    requireNamespace("jsonlite", quietly = TRUE)
    cat(jsonlite::toJSON(x, ...), file = file)
}

#' @importFrom foreign write.arff
#' @export
.export.rio_arff <- function(file, x, ...) {
    write.arff(x = x, file = file, ...)
}

#' @importFrom openxlsx write.xlsx
#' @export
.export.rio_xlsx <- function(file, x, overwrite = TRUE, which, ...) {
    dots <- list(...)
    if (isTRUE(overwrite) || !file.exists(file)) {
        if (!missing(which)) {
            openxlsx::write.xlsx(x = x, file = file, sheetName = which, ...)
        } else {
            openxlsx::write.xlsx(x = x, file = file, ...)
        }
    } else {
        wb <- openxlsx::loadWorkbook(file = file)
        sheets <- openxlsx::getSheetNames(file = file)
        if (is.data.frame(x)) {
            if (missing(which)) {
                which <- paste("Sheet", length(sheets)+1)
            }
            if (!which %in% sheets) {
                openxlsx::addWorksheet(wb, sheet = which)
            }
            openxlsx::writeData(wb, sheet = which, x = x)
            openxlsx::saveWorkbook(wb, file = file, overwrite = TRUE)
        } else {
            wb <- openxlsx::loadWorkbook(file = file)
            mapply(function(sheet, dat) {
                openxlsx::addWorksheet(wb, sheet = sheet)
                openxlsx::writeData(wb, sheet = sheet, x = dat)
            }, names(x), x)
            openxlsx::saveWorkbook(wb, file = file, overwrite = TRUE)
        }
    }
}

#' @export
.export.rio_ods <- function(file, x, ...) {
    requireNamespace("readODS", quietly = TRUE)
    readODS::write_ods(x = x, path = file)
}

#' @export
.export.rio_html <- function(file, x, ...) {
    requireNamespace("xml2", quietly = TRUE)
    html <- xml2::read_html("<!doctype html><html><head>\n<title>R Exported Data</title>\n</head><body>\n</body>\n</html>")
    bod <- xml2::xml_children(html)[[2]]
    if (is.data.frame(x)) {
        x <- list(x)
    }
    for (i in seq_along(x)) {
        x[[i]][] <- lapply(x[[i]], as.character)
        tab <- xml2::xml_add_child(bod, "table")
        # add header row
        invisible(xml2::xml_add_child(tab, xml2::read_xml(paste0(twrap(paste0(twrap(names(x[[i]]), "th"), collapse = ""), "tr"), "\n"))))
        # add data
        for (j in seq_len(nrow(x[[i]]))) {
            xml2::xml_add_child(tab, xml2::read_xml(paste0(twrap(paste0(twrap(unlist(x[[i]][j, , drop = TRUE]), "td"), collapse = ""), "tr"), "\n")))
        }
    }
    xml2::write_xml(html, file = file, ...)
}

#' @export
.export.rio_xml <- function(file, x, ...) {
    requireNamespace("xml2", quietly = TRUE)
    root <- ""
    xml <- xml2::read_xml(paste0("<",as.character(substitute(x)),">\n</",as.character(substitute(x)),">\n"))
    att <- attributes(x)[!names(attributes(x)) %in% c("names", "row.names", "class")]
    for (a in seq_along(att)) {
        xml2::xml_attr(xml, names(att)[a]) <- att[[a]]
    }
    # add data
    for (i in seq_len(nrow(x))) {
        thisrow <- xml2::xml_add_child(xml, "Observation")
        xml2::xml_attr(thisrow, "row.name") <- row.names(x)[i]
        for (j in seq_along(x)) {
            xml2::xml_add_child(thisrow, xml2::read_xml(paste0(twrap(x[i, j, drop = TRUE], names(x)[j]), "\n")))
        }
    }

    xml2::write_xml(xml, file = file, ...)
}

#' @export
.export.rio_yml <- function(file, x, ...) {
    requireNamespace("yaml", quietly = TRUE)
    cat(yaml::as.yaml(x, ...), file = file)
}

#' @export
.export.rio_clipboard <- function(file, x, row.names = FALSE, col.names = TRUE, sep = "\t", ...) {
    requireNamespace("clipr", quietly = TRUE)
    clipr::write_clip(content = x, row.names = row.names, col.names = col.names, sep = sep, ...)
}
