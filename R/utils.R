get_type <- function(fmt) {
    type_list <- list(
        clipboard = "clipboard",
        # supported formats
        "," = "csv",
        ";" = "csv2",
        "\t" = "tsv",
        "|" = "psv",
        arff = "arff",
        csv = "csv",
        csv2 = "csv2",
        csvy = "csvy",
        dbf = "dbf",
        dif = "dif",
        dta = "dta",
        dump = "dump",
        epiinfo = "rec",
        excel = "xlsx",
        feather = "feather",
        fortran = "fortran",
        fst = "fst",
        fwf = "fwf",
        htm = "html",
        html = "html",
        json = "json",
        mat = "matlab",
        matlab = "matlab",
        minitab = "mtp",
        mtp = "mtp",
        ods = "ods",
        psv = "psv",
        r = "r",
        rda = "rdata",
        rdata = "rdata",
        rds = "rds",
        rec = "rec",
        sas = "sas7bdat",
        sas7bdat = "sas7bdat",
        sav = "sav",
        spss = "sav",
        stata = "dta",
        syd = "syd",
        systat = "syd",
        tsv = "tsv",
        txt = "tsv",
        weka = "arff",
        xls = "xls",
        xlsx = "xlsx",
        xml = "xml",
        xport = "xpt",
        xpt = "xpt",
        yaml = "yml",
        yml = "yml",
        # compressed formats
        csv.gz = "gzip",
        csv.gzip = "gzip",
        gz = "gzip",
        gzip = "gzip",
        tar = "tar",
        zip = "zip",
        # known but unsupported formats
        bmp = "bmp",
        gexf = "gexf",
        gnumeric = "gnumeric",
        jpeg = "jpg",
        jpg = "jpg",
        mat = "matlab",
        matlab = "matlab",
        npy = "npy",
        png = "png",
        sdmx = "sdmx",
        sss = "sss",
        tif = "tiff",
        tiff = "tiff"
    )
    out <- type_list[[tolower(fmt)]]
    if (is.null(out)) {
        message("Unrecognized file format. Try specifying with the format argument.")
        return(fmt)
    }
    return(out)
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

twrap <- function(value, tag) {
    paste0("<", tag, ">", value, "</", tag, ">")
}
