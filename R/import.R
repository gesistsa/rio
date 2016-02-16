parse_zip <- function(file, which = 1, ...) {
    file_list <- unzip(file, list = TRUE)
    if (nrow(file_list) > 1) {
        warning("Zip archive contains multiple files. Attempting first file.")
    } else {
        unzip(file, exdir = tempdir())
        paste0(tempdir(),"/", file_list$Name[which])
    }
}

parse_tar <- function(file, which = 1, ...) {
    e <- file_ext(file)
    if (e == "tar") {
        file_list <- untar(file, list = TRUE)
        if (nrow(file_list) > 1) {
            stop("Tar archive contains multiple files. Attempting first file.")
        }
        untar(file, exdir = tempdir())
        paste0(tempdir(),"/", file_list$Name[which])
    } else if (e == "gz") {
        file_list <- untar(file, list = TRUE, compressed = TRUE)
        if (nrow(file_list) > 1) {
            stop("Tar archive contains multiple files. Attempting first file.")
        }
        untar(file, exdir = tempdir(), compressed = TRUE)
        paste0(tempdir(),"/", file_list$Name[which])
    }
}

import_delim <- function(file, fread = TRUE, sep = "auto", header = "auto", stringsAsFactors = FALSE, data.table = FALSE, ...) {
  if (fread) {
    fread(input = file, sep = sep, sep2 = "auto", header = header, stringsAsFactors = stringsAsFactors, data.table = data.table, ...)
  } else {
    if (missing(sep) || is.null(sep) || sep == "auto") {
      sep <- "\t"
    }
    if (missing(header) || is.null(header) || header == "auto") {
      header <- TRUE
    }
    read.table(file = file, sep = sep, header = header, stringsAsFactors = stringsAsFactors, ...)
  }
}

.import.rio_r <- function(file, ...){
  dget(file = file, ...)
}

.import.rio_tsv <- function(file, ...){
  import_delim(file = file, sep = "\t", ...)
}

.import.rio_txt <- function(file, ...){
  import_delim(file = file, sep = "\t", ...)
}

.import.rio_fwf <- function(file, header = FALSE, widths, ...) {
  if (missing(widths)) {
    stop("Import of fixed-width format data requires a 'widths' argument. See `? read.fwf`.")
  }
  read.fwf2(file = file, widths = widths, header = header, ...)
}

.import.rio_rds <- function(file, ...){
  readRDS(file = file, ...)
}

.import.rio_csv <- function(file, ...){
  print(file)
  import_delim(file = file, sep = ",", ...)
}

.import.rio_csv2 <- function(file, ...){
  import_delim(file = file, sep = ";", ...)
}

.import.rio_csvy <- function(file, ...) {
  # read in whole file
  f <- readLines(file)
  
  # identify yaml delimiters
  g <- grep("^#?---", f)
  if (length(g) > 2) {
    stop("More than 2 yaml delimiters found in file")
  } else if (length(g) == 1) {
    stop("Only one yaml delimiter found")
  } else if (length(g) == 0) {
    stop("No yaml delimiters found")
  }
  
  # extract yaml front matter and convert to R list
  y <- yaml.load(paste(gsub("^#", "", f[(g[1]+1):(g[2]-1)]), collapse = "\n"))
  
  # load the data
  out <- import_delim(file = paste0(f[(g[2]+1):length(f)], collapse = "\n"), ...)
  for (i in seq_along(y$fields)) {
    attr(out[, i], "title") <- y$fields[[i]][["title"]]
    attr(out[, i], "description") <- y$fields[[i]][["description"]]
  }

  # store dataset metadata in output data.frame
  if ("fields" %in% names(y)) {
    meta <- c(list(out, names = sapply(y$fields, `[`, "name")), y[!names(y) %in% "names"])
  } else {
    meta <- c(list(out), y)
  }
  out <- do.call("structure", meta)
}

.import.rio_psv <- function(file, ...){
  import_delim(file = file, sep = "|", ...)
}

.import.rio_rdata <- function(file, which = 1, ...) {
  e <- new.env()
  load(file = file, envir = e, ...)
  get(ls(e)[which], e)
}

.import.rio_dta <- function(file, haven = TRUE, column.labels = FALSE, ...) {
  if (haven) {
    a <- list(...)
    if (length(a)) {
      warning("File imported using haven. Arguments to '...' ignored.")
    }
    if (column.labels) {
      return(read_dta(path = file))
    }
    cleanup_haven(read_dta(path = file))
  } else {
    read.dta(file = file, ...)
  }
}

.import.rio_dbf <- function(file, ...){
  read.dbf(file = file, ...)
}

.import.rio_dif <- function(file, ...){
  read.DIF(file = file, ...)
}

.import.rio_sav <- function(file, haven = TRUE, column.labels = FALSE, ...) {
  if (haven) {
    if(column.labels) {
      return(read_sav(path = file))
    }
    cleanup_haven(read_sav(path = file))
  } else {
    read.spss(file = file, to.data.frame = TRUE, ...)
  }
}

.import.rio_por <- function(file, column.labels = FALSE, ...) {
  if(column.labels) {
    return(read_por(path = file))
  }
  cleanup_haven(read_por(path = file))
}

.import.rio_sas7bdat <- function(file, column.labels = FALSE, ...) {
  if(column.labels) {
    return(read_sas(b7dat = file, ...))
  }
  cleanup_haven(read_sas(b7dat = file, ...))
}

.import.rio_xpt <- function(file, ...){
  read.xport(file = file, ...)
}

.import.rio_mtp <- function(file, ...){
  read.mtp(file = file, ...)
}

.import.rio_syd <- function(file, ...){
  read.systat(file = file, to.data.frame = TRUE, ...)
}

.import.rio_json <- function(file, ...){
  fromJSON(txt = file, ...)
}

.import.rio_rec <- function(file, ...){
  read.epiinfo(file = file, ...)
}

.import.rio_arff <- function(file, ...){
  read.arff(file = file)
}

.import.rio_xls <- function(file, ...){
  read_excel(path = file, ...)
}

.import.rio_xlsx <- function(file, readxl = TRUE, ...) {
  if (readxl) {
    read_excel(path = file, ...)
  } else {
    read.xlsx(xlsxFile = file, ...)
  }
}

.import.rio_fortran <- function(file, style, ...) {
    if (missing(style)) {
        stop("Import of Fortran format data requires a 'style' argument. See `? read.fortran`.")
    }
    read.fortran(file = file, format = style, ...)
}

.import.rio_ods <- function(file, header = TRUE, sheet = NULL, ...) {
    handlingODSheader <- function(x) {
        colnames(x) <- x[1,]
        g <- x[2:nrow(x),]
        rownames(g) <- seq(from = 1, to = nrow(g))
        return(g)
    }
    if (getNrOfSheetsInODS(file) > 1 & is.null(sheet)) {
        warning(paste0("There are ", getNrOfSheetsInODS(file), " sheets in the ODS file. Only the first sheet will be returned. Use sheet option from read.ods to select which sheet to import."))
        sheet <- 1
    } else if (getNrOfSheetsInODS(file) == 1) {
        sheet <- 1
    }
    res <- read.ods(file = file, sheet = sheet, ...)
    if (header & !is.data.frame(res)) {
        res <- lapply(res, handlingODSheader)
    }
    if (header & is.data.frame(res)) {
        res <- handlingODSheader(res)
    }
    return(res)
}

.import.rio_xml <- function(file, colClasses = NULL, homogeneous = NA, collectNames = TRUE,
                       stringsAsFactors = FALSE, ...) {
    xmlToDataFrame(doc = xmlParse(file, ...), colClasses = colClasses, homogeneous = homogeneous,
                   collectNames = collectNames, stringsAsFactors = stringsAsFactors)
}

.import.rio_clipboard <- function(header = TRUE, sep = "\t", ...) {
    if (Sys.info()["sysname"] == "Darwin") {
        clip <- pipe("pbpaste")
        read.table(file = clip, sep = sep, ...)
        close(clip)
    } else if(Sys.info()["sysname"] == "Windows") {
        read.table(file = "clipboard", sep = sep, header = header, ...)
    } else {
        stop("Reading from clipboard is not supported on your OS")
    }
}

.import.default <- function(file){
  stop('Unrecognized file format')
}

.import <- function(file, ...){
  UseMethod('.import', file)
}

import <- function(file, format, setclass, ...) {
    if (grepl("^http.*://", file)) {
        file <- remote_to_local(file, format)
    }
    if (!file.exists(file)) {
        stop("No such file")
    }
    if (grepl("zip$", file)) {
        file <- parse_zip(file)
    } else if(grepl("tar$", file) | grepl("gz$", file)) {
        file <- parse_tar(file)
    }
    if (missing(format)) {
        fmt <- get_ext(file)
    } else {
        fmt <- get_type(format)
    }
    stop_for_import(fmt)
    
    class(file) <- paste0("rio_", fmt)
    x <- .import(file = file, ...)
    
    if (missing(setclass)) {
        return(set_class(x))
    }
    
    a <- list(...)
    if ("data.table" %in% names(a) && isTRUE(a[["data.table"]])){
        setclass <- "data.table"
    }
    return(set_class(x, class = setclass))
}
