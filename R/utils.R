#' @title Get File Type from Extension
#' @description A utility function to retrieve the file type from a file extension (via its filename/path/URL)
#' @param file A character string containing a filename, file path, or URL.
#' @return A characters string containing a file type recognized by rio.
#' @examples
#' get_ext("starwars.xlsx")
#' get_ext("starwars.ods")
#' get_ext("clipboard") ## "clipboard"
#' get_ext("https://github.com/ropensci/readODS/raw/v2.1/starwars.ods")
#' @export
get_ext <- function(file) {
    get_info(file)$ext
}

get_info <- function(file) {
    .check_file(file, single_only = TRUE)
    if (tolower(file) == "clipboard") {
        return(.query_format_by_ext(ext = "clipboard", file = "clipboard"))
    }
    if (!grepl("^http.*://", file)) {
        ext <- tolower(tools::file_ext(file))
    } else {
        parsed <- strsplit(strsplit(file, "?", fixed = TRUE)[[1]][1], "/", fixed = TRUE)[[1]]
        url_file <- parsed[length(parsed)]
        ext <- tolower(tools::file_ext(url_file))
    }
    if (ext == "") {
        stop("'file' has no extension", call. = FALSE)
    }
    return(.query_format_by_ext(ext = ext, file = file))
}

.query_format_by_ext <- function(ext, file) {
    unique_rio_formats <- unique(rio_formats[,c(-8)])
    if (file == "clipboard") {
        output <- as.list(unique_rio_formats[unique_rio_formats$format == "clipboard",])
        output$file <- file
        output$ext <- "clipboard" ## for backward compatibility with <= 0.5.30
        return(output)
    }
    ## TODO google sheets
    matched_formats <- unique_rio_formats[unique_rio_formats$input == ext, ]
    if (nrow(matched_formats) == 0) {
        return(list(ext = ext, format = NA, format_name = NA, import_function = NA, export_function = NA, file = file))
    }
    output <- as.list(matched_formats)
    output$file <- file
    return(output)
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
        qs = "qs",
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
        eviews = "eviews",
        wf1 = "eviews",
        zsav = "zsav",
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
        return(fmt)
    }
    return(out)
}

twrap <- function(value, tag) {
    paste0("<", tag, ">", value, "</", tag, ">")
}


escape_xml <- function(x, replacement = c("&amp;", "&quot;", "&lt;", "&gt;", "&apos;")) {
    stringi::stri_replace_all_fixed(
        str = stringi::stri_enc_toutf8(x), pattern = c("&", "\"", "<", ">", "'"),
        replacement = replacement, vectorize_all = FALSE
    )
}

.check_pkg_availability <- function(pkg, lib.loc = NULL) {
    if (identical(find.package(pkg, quiet = TRUE, lib.loc = lib.loc), character(0))) {
        stop("Suggested package `", pkg, "` is not available. Please install it individually or use `install_formats()`", call. = FALSE)
    }
    return(invisible(NULL))
}

.write_as_utf8 <- function(text, file, sep = "") {
    writeLines(enc2utf8(text), con = file, sep = sep, useBytes = TRUE)
}

.check_file <- function(file, single_only = TRUE) {
    ## check the `file` argument
    if (isTRUE(missing(file))) { ## for the case of export(iris, format = "csv")
        return(invisible(NULL))
    }
    if (isFALSE(inherits(file, "character"))) {
        stop("Invalid `file` argument: must be character", call. = FALSE)
    }
    if (isFALSE(length(file) == 1) && single_only) {
        stop("Invalid `file` argument: `file` must be single", call. = FALSE)
    }
    invisible(NULL)
}

.create_directory_if_not_exists <- function(file) {
    file_dir <- dirname(normalizePath(file, mustWork = FALSE))
    if (!dir.exists(file_dir)) {
        dir.create(file_dir, recursive = TRUE)
    }
    invisible(NULL)
}
