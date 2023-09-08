remote_to_local <- function(file, format) {
    if (missing(format)) {
        # handle google sheets urls
        if (grepl("docs\\.google\\.com/spreadsheets", file)) {
            file <- convert_google_url(file, export_as = "csv")
            fmt <- "csv"
        } else {
            # try to extract format from URL
            fmt <- try(get_ext(file), silent = TRUE)
            if (inherits(fmt, "try-error")) {
                fmt <- "TMP"
            }
        }
    } else {
        # handle google sheets urls
        if (grepl("docs\\.google\\.com/spreadsheets", file)) {
            fmt <- .standardize_format(format)
            if (fmt %in% c("csv", "tsv", "xlsx", "ods")) {
                file <- convert_google_url(file, export_as = fmt)
                fmt <- fmt
            } else {
                file <- convert_google_url(file, export_as = "csv")
                fmt <- "csv"
            }
        } else {
            fmt <- .standardize_format(format)
        }
    }
    # save file locally
    temp_file <- tempfile(fileext = paste0(".", fmt))
    u <- curl::curl_fetch_memory(file)
    writeBin(object = u$content, con = temp_file)

    if (fmt == "TMP") {
        # try to extract format from curl's final URL
        fmt <- try(get_ext(u$url), silent = TRUE)
        if (inherits(fmt, "try-error")) {
            # try to extract format from headers
            h1 <- curl::parse_headers(u$headers)
            # check `Content-Disposition` header
            if (any(grepl("^Content-Disposition", h1))) {
                h <- h1[grep("filename", h1)]
                if (length(h)) {
                    f <- regmatches(h, regexpr("(?<=\")(.*)(?<!\")", h, perl = TRUE))
                    if (!length(f)) {
                        f <- regmatches(h, regexpr("(?<=filename=)(.*)", h, perl = TRUE))
                    }
                    f <- paste0(dirname(temp_file), "/", f)
                    file.copy(from = temp_file, to = f)
                    unlink(temp_file)
                    temp_file <- f
                }
            } else {
                stop("Unrecognized file format. Try specifying with the format argument.")
            }
            # check `Content-Type` header
            # if (any(grepl("^Content-Type", h1))) {
            #    h <- h1[grep("^Content-Type", h1)]
            #    ## PARSE MIME TYPE
            # }
        } else {
            f <- sub("TMP$", fmt, temp_file)
            file.copy(from = temp_file, to = f)
            unlink(temp_file)
            temp_file <- f
        }
    }
    return(temp_file)
}
