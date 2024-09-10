#' @title Get File Info
#' @description A utility function to retrieve the file information of a filename, path, or URL.
#' @param file A character string containing a filename, file path, or URL.
#' @return For [get_info()], a list is return with the following slots
#' \itemize{
#'     \item `input` file extension or information used to identify the possible file format
#'     \item `format` file format, see `format` argument of [import()]
#'     \item `type` "import" (supported by default); "suggest" (supported by suggested packages, see [install_formats()]); "enhance" and "known " are not directly supported; `NA` is unsupported
#'     \item `format_name` name of the format
#'     \item `import_function` What function is used to import this file
#'     \item `export_function` What function is used to export this file
#'     \item `file` `file`
#' }
#' For [get_ext()], just `input` (usually file extension) is returned; retained for backward compatibility.
#' @examples
#' get_info("starwars.xlsx")
#' get_info("starwars.ods")
#' get_info("https://github.com/ropensci/readODS/raw/v2.1/starwars.ods")
#' get_info("~/duran_duran_rio.mp3")
#' get_ext("clipboard") ## "clipboard"
#' get_ext("https://github.com/ropensci/readODS/raw/v2.1/starwars.ods")
#' @export
get_info <- function(file) {
    .check_file(file, single_only = TRUE)
    if (tolower(file) == "clipboard") {
        return(.query_format(input = "clipboard", file = "clipboard"))
    }
    if (isFALSE(R.utils::isUrl(file))) {
        ext <- tolower(tools::file_ext(file))
    } else {
        parsed <- strsplit(strsplit(file, "?", fixed = TRUE)[[1]][1], "/", fixed = TRUE)[[1]]
        url_file <- parsed[length(parsed)]
        ext <- tolower(tools::file_ext(url_file))
    }
    if (ext == "") {
        stop("'file' has no extension", call. = FALSE)
    }
    return(.query_format(input = ext, file = file))
}

#' @export
#' @rdname get_info
get_ext <- function(file) {
    get_info(file)$input
}

.query_format <- function(input, file) {
    unique_rio_formats <- unique(rio_formats[, colnames(rio_formats) != "note"])
    if (file == "clipboard") {
        output <- as.list(unique_rio_formats[unique_rio_formats$format == "clipboard", ])
        output$file <- file
        return(output)
    }
    ## TODO google sheets
    matched_formats <- unique_rio_formats[unique_rio_formats$input == input, ]
    if (nrow(matched_formats) == 0) {
        return(list(input = input, format = NA, type = NA, format_name = NA, import_function = NA, export_function = NA, file = file))
    }
    output <- as.list(matched_formats)
    output$file <- file
    return(output)
}

.standardize_format <- function(input) {
    info <- .query_format(input, "")
    if (is.na(info$format)) {
        return(input)
    }
    info$format
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
    if (any(is.na(file))) {
        stop("Invalid `file` argument: `file` must not be NA", call. = FALSE)
    }
    invisible(NULL)
}

.create_directory_if_not_exists <- function(file) {
    R.utils::mkdirs(dirname(normalizePath(file, mustWork = FALSE)))
    invisible(NULL)
}

.create_outfiles <- function(file, x) {
    names_x <- names(x)
    if (length(file) == 1L) {
        if (!grepl("%s", file, fixed = TRUE)) {
            stop("'file' must have a %s placeholder")
        }
        if (is.null(names_x)) {
            return(sprintf(file, seq_along(x)))
        }
        if (!all(nzchar(names_x))) {
            stop("All elements of 'x' must be named or all must be unnamed")
        }
        if (anyDuplicated(names_x)) {
            stop("Names of elements in 'x' are not unique")
        }
        return(sprintf(file, names_x))
    }
    if (length(x) != length(file)) {
        stop("'file' must be same length as 'x', or a single pattern with a %s placeholder")
    }
    if (anyDuplicated(file)) {
        stop("File names are not unique")
    }
    return(file)
}

.check_trust <- function(trust, format) {
    if (is.null(trust)) {
        warning("Missing `trust` will be set to FALSE by default for ", format, " in 2.0.0.", call. = FALSE)
        trust <- TRUE ## Change this for version 2.0.0
    }
    if (isFALSE(trust)) {
        stop(format, " files may execute arbitary code. Only load ", format, " files that you personally generated or can trust the origin.", call. = FALSE)
    }
    NULL
}

.reset_which <- function(file_type, which) {
    ## see #412
    if (file_type %in% c("zip", "tar", "tar.gz", "tar.bz2")) {
        return(1)
    }
    return(which)
}
