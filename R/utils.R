get_type <- function(fmt) {
    type_list <- list(
        txt = "tsv",
        "\t" = "tsv",
        tsv = "tsv",
        csv = "csv",
        csv2 = "csv2",
        csvy = "csvy",
        "," = "csv",
        ";" = "csv2",
        psv = "psv",
        "|" = "psv",
        fwf = "fwf",
        rds = "rds",
        rdata = "rdata",
        dta = "dta",
        stata = "dta",
        dbf = "dbf",
        dif = "dif",
        spss = "sav",
        sav = "sav",
        por = "por",
        sas = "sas7bdat",
        sas7bdat = "sas7bdat",
        xpt = "xpt",
        xport = "xpt",
        mtp = "mtp",
        minitab = "mtp",
        syd = "syd",
        systat = "syd",
        json = "json",
        rec = "rec",
        epiinfo = "rec",
        arff = "arff",
        weka = "arff",
        xls = "xls",
        xlsx = "xlsx",
        excel = "xlsx",
        fortran = "fortran",
        dump = "dump",
        r = "r",
        clipboard = "clipboard",
        ods = "ods",
        xml = "xml",
        # unsupported formats
        gnumeric = "gnumeric",
        jpeg = "jpg",
        jpg = "jpg",
        png = "png",
        bmp = "bmp",
        tif = "tiff",
        tiff = "tiff",
        sss = "sss",
        sdmx = "sdmx",
        mat = "matlab",
        matlab = "matlab",
        gexf = "gexf",
        npy = "npy"
    )
    type <- type_list[[tolower(fmt)]]
    if (is.null(type)) {
        stop("Unrecognized file format. Try specifying with the format argument.",
             call. = FALSE)
    }
    return(type)
}

get_ext <- function(file) {
    if (!is.character(file)) {
        stop("'file' is not a string")
    }
    if (!grepl("^http.*://", file)) {
        fmt <- file_ext(file)
    } else if(grepl("^http.*://", file)) {
        file <- url_parse(file)$path
        fmt <- file_ext(file)
        get_type(fmt)
    }
    if (file == "clipboard") {
        return("clipboard")
    } else if (fmt == "") {
        stop("'file' has no extension")
    } else {
        return(tolower(fmt))
    }
}


convert_google_url <- function(url, export_as = "csv") {
    ## convert a google sheets url to google csv export URL
    ## extract the doc-id and append /export?format = csv to it. (default)
    google_key <- regmatches(url, regexpr("[[:alnum:]_-]{30,}", url))
    if (grepl('gid=[[:digit:]]+', url)) {
        gidpart <- paste0(regmatches(url, regexpr("gid=[[:digit:]]+", url)))
    } else {
        gidpart <- "gid=0"
    }
    return(paste0('https://docs.google.com/spreadsheets/d/', google_key, '/export?', gidpart, '&format=', export_as))
}


remote_to_local <- function(file, format) {
    if (!missing(format)) {
        fmt <- get_type(format)
    }
    # try to extract format from URL
    fmt <- try(get_ext(file), silent = TRUE)
    if (inherits(fmt, "try-error")) {
        fmt <- "TMP"
    }
    # handle google sheets urls
    if (grepl("docs\\.google\\.com/spreadsheets", file)) {
        file <- convert_google_url(file)
        fmt <- "csv"
    }
    # save file locally
    temp_file <- tempfile(fileext = paste0(".", fmt))
    u <- curl_fetch_memory(file)
    writeBin(object = u$content, con = temp_file)
    
    if (fmt == "TMP") {
        # try to extract format from curl's final URL
        fmt <- try(get_ext(u$url), silent = TRUE)
        if (inherits(fmt, "try-error")) {
            # try to extract format from headers
            h1 <- parse_headers(u$headers)
            # check `Content-Disposition` header
            if (any(grepl("^Content-Disposition", h1))) {
                h <- h1[grep("filename", h1)]
                if (length(h)) {
                    f <- regmatches(h, regexpr("(?<=\")(.*)(?<!\")", h, perl = TRUE))
                    if (!length(f)) {
                        f <- regmatches(h, regexpr("(?<=filename=)(.*)", h, perl = TRUE))
                    }
                    f <- paste0(dirname(temp_file), "/", f)
                    file.rename(temp_file, f)
                }
            }
            # check `Content-Type` header
            #if (any(grepl("^Content-Type", h1))) {
            #    h <- h1[grep("^Content-Type", h1)]
            #    ## PARSE MIME TYPE
            #}
        } else {
            f <- sub("TMP$", fmt, temp_file)
            file.rename(temp_file, f)
            temp_file <- f
        }
    }
    return(temp_file)
}

cleanup.haven <- function(x) {
    xinfo <- list(var.labels = sapply(x, attr, which = "label", exact = TRUE),
                  label.table = sapply(x, attr, which = "labels", exact = TRUE))
    discrete <- sapply(x, function(y) length(unique(attr(y, "labels"))) >= length(na.omit(unique(y))))
    x[discrete] <- lapply(x[discrete], as_factor)
    x[sapply(x, is.numeric)] <- lapply(x[sapply(x, is.numeric)], function(y) {
        attr(y, "labels") <- NULL
        return(unclass(y))
    })
    x[] <- lapply(x, function(y) {
        attr(y, "label") <- NULL
        return(y)
    })
    for (a in names(xinfo)) {
        attr(x, a) <- xinfo[[a]]
    }
    return(x)
}
