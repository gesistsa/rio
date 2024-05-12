find_compress <- function(f) {
    if (grepl("\\.zip$", f)) {
        return(list(file = sub("\\.zip$", "", f), compress = "zip"))
    }
    if (grepl("\\.tar\\.gz$", f)) {
        return(list(file = sub("\\.tar\\.gz$", "", f), compress = "tar.gz"))
    }
    if (grepl("\\.tar$", f)) {
        return(list(file = sub("\\.tar$", "", f), compress = "tar"))
    }
    return(list(file = f, compress = NA_character_))
}

## KEEPING OLD CODE FOR LATER REIMPLEMENTATION for gzip and bzip2 #400
##compress_out <- function(cfile, filename, type = c("zip", "tar", "gzip", "bzip2", "xz")) {
compress_out <- function(cfile, filename, type = c("zip", "tar", "tar.gz")) {
    type <- ext <- match.arg(type)
    ## if (ext %in% c("gzip", "bzip2", "xz")) {
    ##     ext <- paste0("tar")
    ## }
    if (missing(cfile)) {
        cfile <- paste0(filename, ".", ext)
        cfile2 <- paste0(basename(filename), ".", ext)
    } else {
        cfile2 <- basename(cfile)
    }
    filename <- normalizePath(filename)
    tmp <- tempfile()
    dir.create(tmp)
    on.exit(unlink(tmp, recursive = TRUE), add = TRUE)
    file.copy(from = filename, to = file.path(tmp, basename(filename)), overwrite = TRUE)
    wd <- getwd()
    on.exit(setwd(wd), add = TRUE)
    setwd(tmp)
    if (type == "zip") {
        o <- utils::zip(cfile2, files = basename(filename))
    }
    if (type == "tar") {
        o <- utils::tar(cfile2, files = basename(filename), compression = "none")
    }
    if (type == "tar.gz") {
        o <- utils::tar(cfile2, files = basename(filename), compression = "gzip")
    }
    setwd(wd)
    if (o != 0) {
        stop(sprintf("File compression failed for %s!", cfile))
    }
    file.copy(from = file.path(tmp, cfile2), to = cfile, overwrite = TRUE)
    unlink(file.path(tmp, cfile2))
    return(cfile)
}

parse_archive <- function(file, which, file_type, ...) {
    if (!file_type %in% c("zip", "tar", "tar.gz")) {
        stop("Unsupported file_type. Use 'zip', 'tar', or 'tar.gz'.")
    }
    if (file_type == "zip") {
        file_list <- utils::unzip(file, list = TRUE)$Name
        extract_func <- utils::unzip
    }
    if (file_type %in% c("tar", "tar.gz")) {
        file_list <- utils::untar(file, list = TRUE)
        extract_func <- utils::untar
    }

    d <- tempfile()
    dir.create(d)

    if (missing(which)) {
        if (length(file_list) > 1) {
            warning(sprintf("%s archive contains multiple files. Attempting first file.", file_type))
        }
        which <- 1
    }

    if (is.numeric(which)) {
        extract_func(file, files = file_list[which], exdir = d)
        return(file.path(d, file_list[which]))
    }
    if (substring(which, 1, 1) != "^") {
        which2 <- paste0("^", which)
    }
    extract_func(file, files = file_list[grep(which2, file_list)[1]], exdir = d)
    return(file.path(d, which))
}
