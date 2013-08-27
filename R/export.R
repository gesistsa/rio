#' Writing data frame or matrix into a file
#'
#' This function exports a data frame or matrix to a file with file format based on the file extension.
#'
#' @param x data frame or matrix to be written into a file.
#' @param file a character string naming a file.
#' @param guess a logocal value ('TRUE' or 'FALSE'). If 'TRUE', the file format will be chosen based on the file extension.
#' @param format a character string code of file format, will override the 'guess' option
#' @param row.names a logical value ('TRUE' or 'FALSE') indicating whether the row names of 'x' are to be written along with 'x'
#' @param ... additional arguments for the underlying export functions.
#' @export

export <- function(x, file="", guess=TRUE, format=NULL, row.names=FALSE, ... ) {
  if (!is.data.frame(x) & !is.matrix(x)) {
    stop("x is not a data frame or matrix.")
  }
  if (is.matrix(x)) {
    x <- as.data.frame(x)
  }
  format <- .guess(file)
  ### DRY(don't repeat yourself) way of doing this, rather than a series of if-else statement
  switch(format,
         txt=write.table(x, file=file, sep="\t", row.names=row.names,...), ##tab-seperate txt file
         rds=saveRDS(x, file=file, ...),
         csv=write.csv(x, file=file, row.names=row.names, ...), 
         dta=write.dta(x, file=file, ...), ### stata
         stop("Unknown file format")
         )
}

#' Reading data frame or matrix from a file
#'
#' This function imports a data frame or matrix from a file with the file format based on the file extension.
#'
#' @param file a character string naming a file.
#' @param guess a logocal value ('TRUE' or 'FALSE'). If 'TRUE', the file format will be chosen based on the file extension.
#' @param format a character string code of file format, will override the 'guess' option
#' @param ... Additional arguments for the underlying export functions.
#' @export

import <- function(file="", guess=TRUE, format=NULL, ... ) {
  format <- .guess(file, format)
  x <- switch(format,
              txt=read.table(file=file, sep="\t", ...), ##tab-seperate txt file
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


.guess <- function(filename, format=NULL) {
  # guess the file format of filename based on file extension
  # TODO: use the unix utility "file" to read the file info.
  # or MIME info.
  if (!is.character(filename)) {
    stop("Filename is not a string")
  }
  if (!is.null(format)) {
    guess_format <- format
  } else {
    guess_format <- str_extract(tolower(filename), "\\.(txt|csv|dta|sav|sas|rec|rds|mtp)$")
  }
  if (is.na(guess_format)) {
    stop("Unknown file format")
  } else {
    return(str_replace(guess_format, "\\.", ""))
  }
}
