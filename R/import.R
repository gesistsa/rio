.import.default <- function(file){
  stop('Unrecognized file format')
}

.import <- function(file, ...){
  UseMethod('.import')
}

import <- function(file, format, setclass, which, ...) {
    if (grepl("^http.*://", file)) {
        file <- remote_to_local(file, format)
    }
    if ((file != "clipboard") && !file.exists(file)) {
        stop("No such file")
    }
    if (grepl("zip$", file)) {
        if (missing(which)) {
            file <- parse_zip(file)
        } else {
            file <- parse_zip(file, which = which)
        }
    } else if(grepl("tar$", file) | grepl("gz$", file)) {
        if (missing(which)) {
            which <- 1
        }
        file <- parse_tar(file, which = which)
    }
    if (missing(format)) {
        fmt <- get_ext(file)
    } else {
        fmt <- get_type(format)
    }
    stop_for_import(fmt)
    
    class(file) <- paste0("rio_", fmt)
    if (missing(which)) {
        x <- .import(file = file, ...)
    } else {
        x <- .import(file = file, which = which, ...)
    }
    
    if (missing(setclass)) {
        return(set_class(x))
    }
    
    a <- list(...)
    if ("data.table" %in% names(a) && isTRUE(a[["data.table"]])){
        setclass <- "data.table"
    }
    return(set_class(x, class = setclass))
}
