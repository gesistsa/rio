find_compress <- function(f) {
    if (grepl("zip$", f)) {
        file <- sub("\\.zip$", "", f)
        compress <- "zip"
    } else if (grepl("tar\\.gz$", f)) {
        file <- sub("\\.tar\\.gz$", "", f)
        compress <- "gzip"
    } else if (grepl("tar$", f)) {
        file <- sub("\\.tar$", "", f)
        compress <- "tar"
    } else if (grepl("gz$", f)) {
        file <- sub("\\.gz$", "", f)
        compress <- "gzip"
    } else {
        file <- f
        compress <- NA_character_
    }
    return(list(file = file, compress = compress))
}

compress_out <- function(cfile, filename, type = c("zip", "tar", "gzip", "bzip2", "xz")) {
    type <- ext <- match.arg(type)
    if (ext %in% c("gzip", "bzip2", "xz")) {
        ext <- paste0("tar")
    }
    if (missing(cfile)) {
        cfile <- paste0(filename, ".", ext)
        cfile2 <- paste0(basename(filename), ".", ext)
    } else {
        cfile2 <- basename(cfile)
    }
    if (type == "zip") {
        o <- zip(cfile2, files = filename)
    } else {
        if (type == "tar") {
            type <- "none"
        }
        filename <- normalizePath(filename)
        tmp <- tempfile()
        dir.create(tmp)
        on.exit(unlink(tmp, recursive = TRUE), add = TRUE)
        file.copy(from = filename, to = file.path(tmp, basename(filename)), overwrite = TRUE)
        unlink(filename)
        wd <- getwd()
        on.exit(setwd(wd), add = TRUE)
        setwd(tmp)
        o <- tar(cfile2, files = ".", compression = type)
        setwd(wd)
        file.rename(file.path(tmp, cfile2), cfile)
    }
    if (o != 0) {
        stop(sprintf("File compresion failed for %s!", cfile))
    }
    return(cfile)
}


parse_zip <- function(file, which, ...) {
    d <- tempfile()
    dir.create(d)
    on.exit(unlink(d))
    file_list <- unzip(file, list = TRUE)
    if (missing(which)) {
        which <- 1
        if (nrow(file_list) > 1) {
            warning(sprintf("Zip archive contains multiple files. Attempting first file."))
        }
    }
    if (is.numeric(which)) {
        unzip(file, files = file_list$Name[which], exdir = d)
        file.path(d, file_list$Name[which])
    } else {
        unzip(file, files = file_list$Name[grep(which, file_list$Name)[1]], exdir = d)
        file.path(d, which)
    }
}

parse_tar <- function(file, which, ...) {
    d <- tempfile()
    dir.create(d)
    on.exit(unlink(d))
    file_list <- untar(file, list = TRUE)
    if (missing(which)) {
        which <- 1
        if (length(file_list) > 1) {
            warning(sprintf("Tar archive contains multiple files. Attempting first file."))
        }
    }
    if (is.numeric(which)) {
        untar(file, files = file_list[which], exdir = d)
        file.path(d, file_list[which])
    } else {
        untar(file, files = file_list[grep(which, file_list)[1]], exdir = d)
        file.path(d, which)
    }
}

