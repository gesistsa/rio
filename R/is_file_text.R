#' @title Determine whether a file is \dQuote{plain-text} or some sort of binary format
#' 
#' @param file       Path to the file
#' @param maxsize    Maximum number of bytes to read
#' @param text_bytes Which characters are used by normal text (though not 
#'                   necessarily just ASCII). To detect just ASCII, the 
#'                   following value can be used: 
#'                   \code{as.raw(c(7:16, 18, 19, 32:127))}
#'
#' @return A logical
#' @export
#' @examples
#' library(datasets)
#' export(iris, yml_file <- tempfile(fileext = ".yml"))
#' is_file_text(yml_file) # TRUE
#' 
#' export(iris, sav_file <- tempfile(fileext = ".sav"))
#' is_file_text(sav_file) # FALSE
#' 
#' # cleanup
#' unlink(yml_file)
#' unlink(sav_file)
#' 
is_file_text <- function(
  file,
  maxsize = Inf, 
  text_bytes = as.raw(c(0x7:0x10, 0x12, 0x13, 0x20:0xFF))
) {
  
  ff <- file(file, "rb")
  bytes <- readBin(
    ff,
    raw(), 
    n = min(file.info(file)$size, maxsize)
  )
  close(ff)

  return(length(setdiff(bytes, text_bytes)) == 0)
}
