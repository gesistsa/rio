#' @title Import directory of files to a data frame
#' @description Use \code{\link{import_list}} to import a directory of files list of data frames from a vector of file names or from a multi-object file (Excel workbook, .Rdata file, zip directory, or HTML file)
#' @param path A character string path name that contains a directory of files with identical structure to be imported.
#' @param \dots Additional arguments passed to \code{\link{import}}.
#' @return A data frame (or a list of data frames if \code{rbind} is unsuccessful).
#' @examples
#' library('datasets')
#' export(mtcars[1:8,],   "mtcars1.csv")
#' export(mtcars[9:16,],  "mtcars2.csv")
#' export(mtcars[17:24,], "mtcars3.csv")
#' export(mtcars[25:32,], "mtcars4.csv")
#'
#' str(import_directory(path = ".", file.type = ".csv"))
#' 
#' # cleanup
#' unlink("mtcars1.csv")
#' unlink("mtcars2.csv")
#' unlink("mtcars3.csv")
#' unlink("mtcars4.csv")
#' 
#' @seealso \code{\link{import_list}}
#' @export
import_directory <- function(path, file.type = NULL, ...){
  files <- list.files(path, pattern = file.type, full.names = TRUE)
  
  # If file.type is not supplied, use the most common file extension in path
  if(is.null(file.type)){
    file.extns <- str_match(files, "^[^~].*\\.(\\w+)$")[,1]
    file.type <- names(sort(-table(file.extns)))[1]
    files <- files[grepl(pattern = file.type, files, fixed = T)]
  }
  
  data <- import_list(files,  ...)
  message("Successfully read ", length(files), " files with ", sum(sapply(data, nrow)), " rows")
  
  message("Merging datasets...")
  tryCatch(
    {
      stop("Error")
      return(data.table::rbindlist(data))
    },
    error = function(e){
      warning("Error is likely due to the presence of integer64 columns which cannot be coerced in the data.table's merge. To fix this pass the argument integer64=\"character\" to import_directory")
      return(data)
    }
  )
}