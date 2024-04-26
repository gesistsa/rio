find_compress <- function(f) {
    if (grepl("zip$", f)) {
        return(list(file = sub("\\.zip$", "", f), compress = "zip"))
    }
    if (grepl("tar\\.gz$", f)) {
        return(list(file = sub("\\.tar\\.gz$", "", f), compress = "tar"))
    }
    if (grepl("tar$", f)) {
        return(list(file = sub("\\.tar$", "", f), compress = "tar"))
    }
    return(list(file = f, compress = NA_character_))
}

compress_out <- function(compress_filename, filename, type = c("zip", "tar", "gzip", "bzip2", "xz")) {
    type <- ext <- match.arg(type)
    if (ext %in% c("gzip", "bzip2", "xz")) {
        ext <- paste0("tar")
    }
    if (missing(compress_filename)) {
        compress_filename <- paste0(filename, ".", ext)
        temp_compress_filename <- paste0(basename(filename), ".", ext)
    } else {
        temp_compress_filename <- basename(compress_filename)
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
        o <- utils::zip(temp_compress_filename, files = basename(filename))
    } else {
        if (type == "tar") {
            type <- "none"
        }
        o <- utils::tar(temp_compress_filename, files = basename(filename), compression = type)
    }
    setwd(wd)
    if (o != 0) {
        stop(sprintf("File compression failed for %s!", compress_filename))
    }
    file.copy(from = file.path(tmp, temp_compress_filename), to = compress_filename, overwrite = TRUE)
    unlink(file.path(tmp, temp_compress_filename))
    return(compress_filename)
}

parse_archive <- function(file, which, file_type, ...) {
    if (file_type == "zip") {
        file_list <- utils::unzip(file, list = TRUE)$Name
        extract_func <- utils::unzip
    } else if (file_type == "tar") {
        file_list <- utils::untar(file, list = TRUE)
        extract_func <- utils::untar
    } else {
        stop("Unsupported file_type. Use 'zip' or 'tar'.")
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
