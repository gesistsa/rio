#' Writing data frame or matrix into a file
#'
#' This function exports a data frame or matrix into a data file with file format based on the file extension.
#'
#' @param x data frame or matrix to be written into a file.
#' @param file a character string naming a file.
#' @param format a character string code of file format. The following file formats are supported: txt, csv, tsv, rds, Rdata, json, dbf, sav, dta, xlsx, and arff.
#' @param row.names a logical value ('TRUE' or 'FALSE') indicating whether the row names of 'x' are to be written along with 'x'
#' @param header a logical value indicating whether the file contains the names of the variables as its first line. 
#' @param ... additional arguments for the underlying export functions.
#' @return The name of the output file (invisibly).
#' @examples
#' export(iris, "iris.csv")
#' @export

export <- function(x, file="", format=NULL, row.names=FALSE, header=TRUE, ... ) {
  if (!is.data.frame(x) & !is.matrix(x)) {
    stop("x is not a data frame or matrix.")
  }
  if (is.matrix(x)) {
    x <- as.data.frame(x)
  }
  format <- .guess(file)
  switch(format,
         txt = write.table(x, file=file, sep="\t", row.names=row.names, col.names=header, ...),
         tsv = write.table(x, file=file, sep="\t", row.names=row.names, col.names=header, ...),
         clipboard = {
            if(Sys.info()["sysname"] == "Darwin") {
                clip <- pipe("pbcopy", "w")                       
                write.table(x, file = clip, sep="\t", row.names=row.names, col.names=header, ...)
                close(clip)
            } else if(Sys.info()["sysname"] == "Windows") {
                write.table(x, file="clipboard", sep="\t", row.names=row.names, col.names=header, ...)
            }
         },
         rds = saveRDS(x, file=file, ...),
         csv = write.csv(x, file=file, row.names=row.names, ...), 
         rdata = save(x, file = file, ...),
         sav = haven::write_sav(data = x, path = file),
         dta = haven::write_dta(data = x, path = file),
         dbf = foreign::write.dbf(dataframe = x, file = file, ...),
         json = cat(jsonlite::toJSON(x, ...), file = file),
         arff = foreign::write.arff(x = x, file = file, ...),
         xlsx = openxlsx::write.xlsx(x = x, file = file, ...),
         stop("Unknown file format")
         )
  invisible(file)
}

#' Reading data frame or matrix from a file
#'
#' This function imports a data frame or matrix from a data file with the file format based on the file extension.
#'
#' @param file a character string naming a file.
#' @param format a character string code of file format. The following file formats are supported: txt, tsv, csv, rds, Rdata, dta, sav, por, mtp, json, dif, rec, dbf, sas7bdat, syd, xlsx, arff, xpt, and fwf (fixed-width format; requires a \code{widths} argument).
#' @param header a logical value indicating whether the file contains the names of the variables as its first line. 
#' @param ... Additional arguments for the underlying import functions.
#' @return An R dataframe.
#' @note For csv and txt files with row names exported from export(), additional ... argument of row.names might be useful to specify the column of the table which contain row names. See example below. 
#' @examples
#' #x <- import("iris.dta")
#' myIris <- datasets::iris
#' export(myIris, "myIris.csv", row.names=TRUE)
#' myIris2 <- import("myIris.csv") ### with the additional spurious column
#' head(myIris2)
#' myIris3 <- import("myIris.csv", row.names=1)
#' head(myIris3)
#' @export

import <- function(file="", format=NULL, header=TRUE, ... ) {
  format <- .guess(file, format)
  x <- switch(format,
              txt = read.table(file=file, sep="\t", header=header, ...),
              tsv = read.table(file=file, sep="\t", header=header, ...),
              fwf = utils::read.fwf(file = file, header = header, ...),
              rds = readRDS(file=file, ...),
              csv = read.csv(file=file, header=header, ...),
              rdata = { e <- new.env(); load(file = file, envir = e, ...); get(ls(e)[1], e) }, # return first object from a .Rdata
              dta = haven::read_dta(path = file),
              dbf = foreign::read.dbf(file = file, ...),
              dif = utils::read.DIF(file = file, ...),
              sav = haven::read_sav(path = file),
              por = haven::read_por(path = file),
              sas7bdat = haven::read_sas(b7dat = file, ...),
              mtp = foreign::read.mtp(file=file, ...),
              syd = foreign::read.systat(file = file, to.data.frame = TRUE),
              json = jsonlite::fromJSON(file = file, ...),
              rec = foreign::read.epiinfo(file=file, ...),
              arff = foreign::read.arff(file = file),
              xpt = foreign::read.xport(file = file),
              xlsx = openxlsx::read.xlsx(xlsxFile = file, colNames = header, ...),
              stop("Unknown file format")
              )
  return(x)
}

#' Convert from one file format to another
#'
#' This function constructs a data frame from a data and exports to the specified format based on the file extension.
#'
#' @param in_file a character string naming an input file.
#' @param out_file a character string naming an output file.
#' @param in_opts a named list of options to be passed to \code{\link{import}}
#' @param out_opts a named list of options to be passed to \code{\link{export}}
#' @return The name of the output file (invisibly).
#' @examples
#' export(iris, "iris.csv")
#' convert("iris.csv", "iris.dta")
#' import("iris.dta")
#' @export

convert <- function(in_file, out_file, in_opts=list(), out_opts=list()) {
    invisible(do.call("export", c(list(file = out_file, x = do.call("import", c(list(file=in_file), in_opts))), out_opts)))
}


#### internal helper function to handle the pre-condition of the import and export functions
#### Not export and no doc

.guess <- function(filename, format=NULL) {
  # guess the file format of filename based on file extension
  # TODO: use the unix utility "file" to read the file info.
  # or MIME info.
  if (!is.character(filename)) {
    stop("Filename is not a string")
  }
  guess_format <- ifelse(!is.null(format), tolower(format), 
                         str_extract(tolower(filename), 
                         "\\.(txt|tsv|csv|json|rdata|dta|sav|por|rec|rds|dbf|syd|dif|fwf|mtp|xlsx|sas7bdat|xpt)$"))
  if(filename == "clipboard") {
    return("clipboard")
  } else if (is.na(guess_format)) {
    stop("Unknown file format")
  } else {
    return(str_replace(guess_format, "\\.", ""))
  }
}
