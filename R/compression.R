find_compress <- function(f) {
    if (grepl("\\.zip$", f)) {
        return(list(file = sub("\\.zip$", "", f), compress = "zip"))
    }
    if (grepl("\\.tar\\.gz$", f)) {
        return(list(file = sub("\\.tar\\.gz$", "", f), compress = "tar.gz"))
    }
    if (grepl(".tgz$", f)) {
        return(list(file = sub("\\.tgz$", "", f), compress = "tar.gz"))
    }
    if (grepl("\\.tar\\.bz2$", f)) {
        return(list(file = sub("\\.tar\\.bz2$", "", f), compress = "tar.bz2"))
    }
    if (grepl("\\.tbz2$", f)) {
        return(list(file = sub("\\.tbz2$", "", f), compress = "tar.bz2"))
    }
    if (grepl("\\.tar$", f)) {
        return(list(file = sub("\\.tar$", "", f), compress = "tar"))
    }
    if (grepl("\\.gzip$", f)) {
        ## weird
        return(list(file = sub("\\.gzip$", "", f), compress = "gzip"))
    }
    if (grepl("\\.gz$", f)) {
        return(list(file = sub("\\.gz$", "", f), compress = "gzip"))
    }
    if (grepl("\\.bz2$", f)) {
        return(list(file = sub("\\.bz2$", "", f), compress = "bzip2"))
    }
    if (grepl("\\.bzip2$", f)) {
        ## weird
        return(list(file = sub("\\.bzip2$", "", f), compress = "bzip2"))
    }
    return(list(file = f, compress = NA_character_))
}

compress_out <- function(cfile, filename, type = c("zip", "tar", "tar.gz", "tar.bz2", "gzip", "bzip2")) {
    type <- ext <- match.arg(type)
    cfile2 <- basename(cfile)
    filename <- normalizePath(filename)
    if (type %in% c("gzip", "bzip2")) {
        return(.compress_rutils(filename, cfile, ext = ext))
    }
    tmp <- tempfile()
    dir.create(tmp)
    on.exit(unlink(tmp, recursive = TRUE), add = TRUE)
    file.copy(from = filename, to = file.path(tmp, basename(filename)), overwrite = TRUE)
    wd <- getwd()
    on.exit(setwd(wd), add = TRUE) ## for security, see #438 and #319
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
    if (type == "tar.bz2") {
        o <- utils::tar(cfile2, files = basename(filename), compression = "bzip2")
    }
    setwd(wd) ## see #438
    if (o != 0) {
        stop(sprintf("File compression failed for %s!", cfile))
    }
    file.copy(from = file.path(tmp, cfile2), to = cfile, overwrite = TRUE)
    return(cfile)
}

parse_archive <- function(file, which, file_type, ...) {
    if (file_type %in% c("gzip", "bzip2")) {
        ## it doesn't have the same interface as unzip
        return(.parse_rutils(filename = file, file_type = file_type))
    }
    if (file_type == "zip") {
        extract_func <- utils::unzip
    }
    if (file_type %in% c("tar", "tar.gz", "tar.bz2")) {
        extract_func <- utils::untar
    }
    file_list <- .list_archive(file, file_type)
    d <- tempfile()
    dir.create(d)

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

.list_archive <- function(file, file_type = c("zip", "tar", "tar.gz", "tar.bz2")) {
    ## just a simple wrapper to unify the interface of utils::unzip and utils::untar
    file_type <- match.arg(file_type)
    if (file_type == "zip") {
        file_list <- utils::unzip(file, list = TRUE)$Name
    }
    if (file_type %in% c("tar", "tar.gz", "tar.bz2")) {
        file_list <- utils::untar(file, list = TRUE)
    }
    return(file_list)
}

.compress_rutils <- function(filename, cfile, ext, remove = TRUE, FUN = gzfile) {
    ## Caution: Please note that remove = TRUE by default, it will delete `filename`!
    if (ext == "bzip2") {
        FUN <- bzfile
    }
    tmp_cfile <- R.utils::compressFile(filename = filename, destname = tempfile(), ext = ext, FUN = FUN, overwrite = TRUE, remove = remove)
    file.copy(from = tmp_cfile, to = cfile, overwrite = TRUE)
    unlink(tmp_cfile)
    return(cfile)
}

.parse_rutils <- function(filename, file_type) {
    if (file_type == "gzip") {
        decompression_fun <- gzfile
    }
    if (file_type == "bzip2") {
        decompression_fun <- bzfile
    }
    destname <- tempfile()
    R.utils::decompressFile(filename = filename, destname = destname, temporary = TRUE, remove = FALSE, overwrite = TRUE, FUN = decompression_fun, ext = file_type)
}

.check_tar_support <- function(file_type, rversion) {
    if (file_type %in% c("tar", "tar.gz", "tar.bz2") && rversion < "4.0.3") {
        stop("Exporting to tar formats is not supported for this version of R.", call. = FALSE)
    }
    NULL
}

.get_compressed_format <- function(cfile, file, file_type, format) {
    if (file_type %in% c("gzip", "bzip2")) {
        return(ifelse(isFALSE(missing(format)), tolower(format), get_info(find_compress(cfile)$file)$input))
    }
    ## zip or tar formats, use the decompressed file path
    return(ifelse(isFALSE(missing(format)), tolower(format), get_info(file)$input))
}
