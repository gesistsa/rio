.export.default <- function(file, x, ...){
  stop("Unrecognized file format")
}

.export <- function(file, x, ...){
  UseMethod(".export")
}

export <- function(x, file, format, ...) {
    if (missing(file) & missing(format)) {
        stop("Must specify 'file' and/or 'format'")
    } else if (!missing(file) & !missing(format)) {
        fmt <- tolower(format)
        cfile <- file
        f <- find_compress(file)
        file <- f$file
        compress <- f$compress
    } else if (!missing(file) & missing(format)) {
        cfile <- file
        f <- find_compress(file)
        file <- f$file
        compress <- f$compress
        fmt <- get_ext(file)
    } else if (!missing(format)) {
        fmt <- get_type(format)
        file <- paste0(as.character(substitute(x)), ".", fmt)
        compress <- NA_character_
    }
    
    if (!is.data.frame(x) & !is.matrix(x)) {
        stop("'x' is not a data.frame or matrix")
    } else if (is.matrix(x)) {
        x <- as.data.frame(x)
    }
    stop_for_export(fmt)
    
    class(file) <- paste0("rio_", fmt)
    .export(file = file, x = x, ...)
    
    if (!is.na(compress)) {
        cfile <- compress_out(cfile = cfile, filename = file, type = compress)
        unlink(file)
        return(invisible(cfile))
    }
    
    invisible(unclass(file))
}
