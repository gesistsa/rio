#' @title Get File Type from Extension
#' @description A utility function to retrieve the file type from a file extension (via its filename/path/URL)
#' @param file A character string containing a filename, file path, or URL.
#' @return A characters string containing a file type recognized by rio.
#' @export
get_ext <- function(file) {
    if (!is.character(file)) {
        stop("'file' is not a string")
    }
    if (!grepl("^http.*://", file)) {
        fmt <- tools::file_ext(file)
    } else if(grepl("^http.*://", file)) {
        parsed <- strsplit(strsplit(file, "?", fixed = TRUE)[[1]][1], "/", fixed = TRUE)[[1]]
        file <- parsed[length(parsed)]
        fmt <- tools::file_ext(file)
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
        por = "spss",
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
        sql = "sql",
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
        bib = "bib",
        bibtex = "bib",
        bmp = "bmp",
        gexf = "gexf",
        gnumeric = "gnumeric",
        jpeg = "jpg",
        jpg = "jpg",
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

twrap <- function(value, tag) {
    paste0("<", tag, ">", value, "</", tag, ">")
}

# Get table names from SQL dump script
get_sql_tablenames <- function(file) {
  tables <- readLines(system.file("examples/example.sql", package = packageName(), mustWork = TRUE))
  tables <- grep("CREATE TABLE", tables, ignore.case = TRUE, value = TRUE)
  tables <- gsub("CREATE TABLE (.+?) .*", "\\1", tables, ignore.case = TRUE)
  tables
}
