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
        yml = "yml",
        yaml = "yml",
        # known but unsupported formats
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
