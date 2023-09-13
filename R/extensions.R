.import <- function(file, ...) {
    UseMethod(".import")
}

.import.default <- function(file, ...) {
    fileinfo <- get_info(file)
    if (is.na(fileinfo$type) || is.na(fileinfo$import_function) || fileinfo$import_function == "") {
        stop("Format not supported", call. = FALSE)
    }
    if (fileinfo$type == "known") {
        stop(sprintf(gettext("%s format not supported. Consider using the '%s()' function"),
                     fileinfo$format, fileinfo$import_function), call. = FALSE)
    }
    if (fileinfo$type == "enhance") {
        pkg <- stringi::stri_extract_first(fileinfo$import_function, regex = "[a-zA-Z0-9\\.]+")
        stop(sprintf(gettext("Import support for the %s format is exported by the %s package. Run 'library(%s)' then try again."),
                     fileinfo$format, pkg, pkg), call. = FALSE)
    }
}

.export <- function(file, x, ...) {
    UseMethod(".export")
}

.export.default <- function(file, x, ...) {
    fileinfo <- get_info(file)
    if (is.na(fileinfo$type) || is.na(fileinfo$export_function) || fileinfo$export_function == "") {
        stop("Format not supported", call. = FALSE)
    }
    if (fileinfo$type == "known") {
        stop(sprintf(gettext("%s format not supported. Consider using the '%s()' function"),
                     fileinfo$format, fileinfo$export_function), call. = FALSE)
    }
}
