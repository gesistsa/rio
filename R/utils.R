get_type <- function(fmt) {
    type_list <- list(
        txt = "tsv", # decide on this
        tsv = "tsv",
        csv = "csv",
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
        xlsx = "xlsx",
        excel = "xlsx",
        fortran = "fortran",
        zip = "zip",
        tar = "tar",
        r = "r",
        clipboard = "clipboard"
    )
    type <- type_list[[tolower(fmt)]]
    if(is.null(type)) {
        stop("Unrecognized file format")
    } else {
        return(type)
    }
}

get_ext <- function(file) {
    if (!is.character(file)) {
        stop("'file' is not a string")
    }
    if(!grepl("^http.*://", file)) {
        fmt <- file_ext(file)
    }
    else if(grepl("^http.*://", file)) {
        fmt <- gsub("(.*\\/)([^.]+)\\.", "", file)
    }
    if(file == "clipboard") {
        return("clipboard")
    } else if (fmt == "") {
        stop("'file' has no extension")
    } else {
        return(tolower(fmt))
    }
}
