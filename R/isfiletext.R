#' Determine whether a file is "plain-text" or some sort of binary format
#'
#' @param filename Path to the file
#' @param maxsize  Maximum number of bytes to read
#' @param textbytes Which characters are used by normal (though not necessarily 
#'                  just ASCII) text. To detect just ASCII, the following value
#'                  can be used: `as.raw(c(7:16,18,19,32:127))`
#' @param tf       If `TRUE` (default) simply return `TRUE` when `filename` 
#'                 references a text-only file and `FALSE` otherwise. If set to
#'                 `FALSE` then returns the "non text" bytes found in the file.
#'
#' @return boolean or raw
#' @export
#' @examples
#' library(datasets)
#' export(iris,"iris.yml")
#' isfiletext("iris.yml")
#' ## TRUE
#' 
#' export(iris,"iris.sav")
#' isfiletext("iris.sav")
#' ## FALSE
#' isfiletext("iris.sav", tf=FALSE)
#' ## These are the characters found in "iris.sav" that are not printable text
#' ## 02 00 05 03 06 04 01 14 15 11 17 16 1c 19 1b 1a 18 1e 1d 1f
isfiletext <- function(filename,maxsize=Inf,
                       textbytes=as.raw(c(0x7:0x10,0x12,0x13,0x20:0xFF)),
                       tf=TRUE){
  bytes <- readBin(ff<-file(filename,'rb'),raw(),n=min(file.info(filename)$size,
                                                       maxsize));
  close(ff);
  nontextbytes <- setdiff(bytes,textbytes);
  if(tf) return(length(nontextbytes)==0) else return(nontextbytes);
}