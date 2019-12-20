#' Determine whether a file is "plain-text" or some sort of binary format
#' 
#' For debugging (i.e. why is a file being deemed non-text) set the option
#' \code{"rio.is_file_text.debug"} to \code{TRUE}. Then the result returned will 
#' also have an attribute named \code{"non_text_bytes"} which will be a vector 
#' of the raw bytes which prevented the file from being identified as text
#' 
#' @param file       Path to the file
#' @param maxsize    Maximum number of bytes to read
#' @param text_bytes Which characters are used by normal text (though not 
#'                   necessarily just ASCII). To detect just ASCII, the 
#'                   following value can be used: 
#'                   \code{as.raw(c(7:16, 18, 19, 32:127))}
#'
#' @return boolean
#' @export
#' @examples
#' library(datasets)
#' export(iris, "iris.yml")
#' is_file_text("iris.yml")
#' ## TRUE
#' 
#' export(iris, "iris.sav")
#' is_file_text("iris.sav")
#' ## FALSE
#' 
is_file_text <- function(file, maxsize = Inf, 
                       text_bytes = as.raw(c(0x7:0x10, 0x12, 0x13, 0x20:0xFF))) {
  
  bytes <- readBin(ff <- file(file, "rb"), raw(), 
                   n = min(file.info(file)$size, maxsize))
  close(ff)

  non_text_bytes <- setdiff(bytes, text_bytes)
  result <- length(non_text_bytes) == 0
  if (getOption("rio.is_file_text.debug", FALSE)) {
    attr(result, "non_text_bytes") <- non_text_bytes
  }
  
  return(result)
}