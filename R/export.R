#' Writing data frame or matrix into a file
#'
#' This function exports a data frame or matrix into a data file with file format based on the file extension.
#'
#' @param x data frame or matrix to be written into a file.
#' @param file a character string naming a file.
#' @param format a character string code of file format. The following file formats are supported: txt, rds, csv and dta.
#' @param row.names a logical value ('TRUE' or 'FALSE') indicating whether the row names of 'x' are to be written along with 'x'
#' @param header a logical value indicating whether the file contains the names of the variables as its first line. 
#' @param ... additional arguments for the underlying export functions.
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
  ### DRY(don't repeat yourself) way of doing this, rather than a series of if-else statement
  switch(format,
         txt=write.table(x, file=file, sep="\t", row.names=row.names, col.names=header,...), ##tab-seperate txt file
         rds=saveRDS(x, file=file, ...),
         csv=write.csv(x, file=file, row.names=row.names, ...), 
         dta=write.dta(x, file=file, ...), ### stata
         stop("Unknown file format")
         )
}

#' Reading data frame or matrix from a file
#'
#' This function imports a data frame or matrix from a data file with the file format based on the file extension.
#'
#' @param file a character string naming a file.
#' @param format a character string code of file format. The following file formats are supported: txt, rds, csv, dta, sav, mtp and rec.
#' @param header a logical value indicating whether the file contains the names of the variables as its first line. 
#' @param ... Additional arguments for the underlying export functions.
#' @examples
#' #x <- import("iris.dta")
#' @export

import <- function(file="", format=NULL, header=TRUE, ... ) {
  format <- .guess(file, format)
  x <- switch(format,
              txt=read.table(file=file, sep="\t", header=header, ...), ##tab-seperate txt file
              rds=readRDS(file=file, ...),
              csv=read.csv(file=file, ...),
              dta=read.dta(file=file, ...),
              sav=read.spss(file=file,to.data.frame=TRUE, ...),
              mtp=read.mtp(file=file, ...),
              rec=read.epiinfo(file=file, ...),
              stop("Unknown file format")
              )
  return(x)
}

#convert <- function(in_file, out_file, in_format=NULL, out_format=NULL, row.names=FALSE, ...) {
#    export(import(file=in_file, format=in_format, ...), file=out_file, format=out_format, row.names=row.names, ...)
#}


#### internal helper function to handle the pre-condition of the import and export functions
#### Not export and no doc

.guess <- function(filename, format=NULL) {
  # guess the file format of filename based on file extension
  # TODO: use the unix utility "file" to read the file info.
  # or MIME info.
  if (!is.character(filename)) {
    stop("Filename is not a string")
  }
  guess_format <- ifelse(!is.null(format), tolower(format), str_extract(tolower(filename), "\\.(txt|csv|dta|sav|sas|rec|rds|mtp)$"))
  if (is.na(guess_format)) {
    stop("Unknown file format")
  } else {
    return(str_replace(guess_format, "\\.", ""))
  }
}
