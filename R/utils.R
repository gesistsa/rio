get_type <- function(fmt) {
    type_list <- list(
        txt = "tsv",
        "\t" = "tsv",
        tsv = "tsv",
        csv = "csv",
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
    if(is.null(type)) {
        stop("Unrecognized file format. Try specifying with the format argument.",
             call. = FALSE)
    } 
    return(type)
}

get_ext <- function(file) {
    if (!is.character(file)) {
        stop("'file' is not a string")
    }
    if(!grepl("^http.*://", file)) {
        fmt <- file_ext(file)
    } else if(grepl("^http.*://", file)) {
        file <- get_type(url_parse(file)$path)
        fmt <- gsub("(.*\\/)([^.]+)\\.", "", file)
        get_type(fmt)
    }
    if(file == "clipboard") {
        return("clipboard")
    } else if (fmt == "") {
        stop("'file' has no extension")
    } else {
        return(tolower(fmt))
    }
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
