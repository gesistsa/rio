## @rdname extensions
## @aliases extensions .import .export
## @title rio Extensions
## @description Writing Import/Export Extensions for rio
## @param file A character string naming a file.
## @param x A data frame or matrix to be written into a file.
## @param \dots Additional arguments passed to methods.
## @return For \code{.import}, an R data.frame. For \code{.export}, \code{file}, invisibly.
## @details rio implements format-specific S3 methods for each type of file that can be imported from or exported to. This happens via internal S3 generics, \code{.import} and \code{.export}. It is possible to write new methods like with any S3 generic (e.g., \code{print}).
##
## As an example, \code{.import.rio_csv} imports from a comma-separated values file. If you want to produce a method for a new filetype with extension \dQuote{myfile}, you simply have to create a function called \code{.import.rio_myfile} that implements a format-specific importing routine and returns a data.frame. rio will automatically recognize new S3 methods, so that you can then import your file using: \code{import("file.myfile")}.
##
## As general guidance, if an import method creates many attributes, these attributes should be stored --- to the extent possible --- in variable-level attributes fields. These can be \dQuote{gathered} to the data.frame level by the user via \code{\link{gather_attrs}}.
## @seealso \code{\link{import}}, \code{\link{export}}
.import <- function(file, ...) {
    UseMethod(".import")
}

## @rdname extensions
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

## @rdname extensions
.export <- function(file, x, ...) {
    UseMethod(".export")
}

## @rdname extensions
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
