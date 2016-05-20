remote_to_local <- function(file, format) {
    if (missing(format)) {
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
    } else {
        fmt <- get_type(format)
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
                    file.copy(from = temp_file, to = f)
                    unlink(temp_file)
                    temp_file <- f
                }
            } else {
                stop("Unrecognized file format. Try specifying with the format argument.")
            }
            # check `Content-Type` header
            #if (any(grepl("^Content-Type", h1))) {
            #    h <- h1[grep("^Content-Type", h1)]
            #    ## PARSE MIME TYPE
            #}
        } else {
            f <- sub("TMP$", fmt, temp_file)
            file.copy(from = temp_file, to = f)
            unlink(temp_file)
            temp_file <- f
        }
    }
    return(temp_file)
}
