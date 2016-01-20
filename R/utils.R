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
