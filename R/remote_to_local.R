remote_to_local <- function(file, format) {
    if (grepl("docs\\.google\\.com/spreadsheets", file)) {
        if (missing(format) || (!missing(format) && !format %in% c("csv", "tsv", "xlsx", "ods"))) {
            format <- "csv"
        }
        file <- convert_google_url(file, export_as = format)
    }
    if (missing(format)) {
        ## try to extract format from URL
        format <- try(get_info(file)$format, silent = TRUE)
        if (inherits(format, "try-error")) {
            format <- "TMP"
        }
    } else {
        format <- .standardize_format(format)
    }
    # save file locally
    temp_file <- tempfile(fileext = paste0(".", format))
    u <- curl::curl_fetch_memory(file)
    writeBin(object = u$content, con = temp_file)
    if (format == "TMP") {
        # try to extract format from curl's final URL
        format <- try(get_info(u$url)$format, silent = TRUE)
        if (inherits(format, "try-error")) {
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
            f <- sub("TMP$", format, temp_file)
            file.copy(from = temp_file, to = f)
            unlink(temp_file)
            temp_file <- f
        }
    }
    return(temp_file)
}
