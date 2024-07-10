remote_to_local <- function(file, format) {
    if (grepl("docs.google.com/spreadsheets", file, fixed = TRUE)) {
        if (missing(format) || (!missing(format) && !format %in% c("csv", "tsv", "xlsx", "ods"))) {
            format <- "csv"
        }
        file <- .convert_google_url(file, export_as = format)
    }
    if (missing(format)) {
        ## try to extract format from URL, see below
        format <- .get_ext_temp(file)
    } else {
        format <- .standardize_format(format)
    }
    # save file locally
    temp_file <- tempfile(fileext = paste0(".", format))
    u <- curl::curl_fetch_memory(file)
    writeBin(object = u$content, con = temp_file)
    if (format != "TMP") { ## the happiest path
        return(temp_file)
    }
    ## fomart = "TMP": try to extract format from curl's final URL
    format <- .get_ext_temp(u$url)
    if (format != "TMP") { ## contain a file extension, also happy
        renamed_file <- sub("TMP$", format, temp_file)
        file.copy(from = temp_file, to = renamed_file)
        unlink(temp_file)
        return(renamed_file)
    }
    ## try to extract format from headers: read #403 about whether this code is doing anything
    h1 <- curl::parse_headers(u$headers)
    ## check `Content-Disposition` header
    if (!any(grepl("^Content-Disposition", h1))) {
        stop("Unrecognized file format. Try specifying with the format argument.")
    }
    h <- h1[grep("filename", h1, fixed = TRUE)]
    if (length(h)) {
        f <- regmatches(h, regexpr("(?<=\")(.*)(?<!\")", h, perl = TRUE))
        if (!length(f)) {
            f <- regmatches(h, regexpr("(?<=filename=)(.*)", h, perl = TRUE))
        }
        f <- file.path(dirname(temp_file), f)
        file.copy(from = temp_file, to = f)
        unlink(temp_file)
        return(f)
    }
}

.convert_google_url <- function(url, export_as = "csv") {
    ## convert a google sheets url to google csv export URL
    ## extract the doc-id and append /export?format = csv to it. (default)
    google_key <- regmatches(url, regexpr("[[:alnum:]_-]{30,}", url))
    if (grepl("gid=[[:digit:]]+", url)) {
        gidpart <- paste0(regmatches(url, regexpr("gid=[[:digit:]]+", url)))
    } else {
        gidpart <- "gid=0"
    }
    return(paste0("https://docs.google.com/spreadsheets/d/", google_key, "/export?", gidpart, "&format=", export_as))
}

.get_ext_temp <- function(file, temp_format = "TMP") {
    ## This is a version of get_ext for internal usage
    ## When file can't be queried, return `temp_format` instead of error
    format <- try(get_info(file)$format, silent = TRUE)
    if (inherits(format, "try-error")) {
        return(temp_format)
    }
    return(format)
}
