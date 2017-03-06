#' @rdname import
#' @title Import list of data frames
#' @description Use \code{\link{import}} to import a list of data frames from a vector of file names or from a multi-object file (Excel workbook, zip directory, HTML file)
#' @param file A character string containing a single file name for a multi-object file (e.g., Excel workbook, zip directory, or HTML file), or a vector of file paths for multiple files to be imported.
#' @param which If \code{file} is a single file path, this specifies which objects should be extracted (passed to \code{\link{import}}'s \code{which} argument). Ignored otherwise.
#' @param \dots Additional arguments passed to \code{\link{import}}. Behavior may be unexpected if files are of different formats.
#' @return A list of a data frames.
#' @examples
#' library('datasets')
#' export(list(iris = iris, mtcars = mtcars), "data.xlsx")
#' 
#' # import a single file from multi-object workbook
#' str(import("data.xlsx", which = "mtcars"))
#' 
#' # import all worksheets
#' str(import_list("data.xlsx"))
#' 
#' # import multiple files
#' export(mtcars, "mtcars.csv")
#' export(mtcars, "iris.csv")
#' str(import_list(c("mtcars.csv", "iris.csv")))
#' 
#' # cleanup
#' unlink("data.xlsx")
#' unlink("mtcars.csv")
#' unlink("iris.csv")
#' 
#' @seealso \code{\link{import}}
#' @export
import_list <- function(file, which, ...) {
    if (length(file) > 1) {
        lapply(file, import, ...)
    } else {
        if (missing(which)) {
            if (get_ext(file) == "html") {
                requireNamespace("xml2")
                which <- seq_along(xml2::xml_find_all(xml2::read_html(unclass(file)), ".//table"))
            } else if (get_ext(file) %in% c("xls","xlsx")) {
                requireNamespace("readxl")
                which <- seq_along(readxl::excel_sheets(path = file))
            } else if (get_ext(file) %in% c("zip")) {
                which <- seq_len(nrow(utils::unzip(file, list = TRUE)))
            } else {
                which <- 1
            }
        }
        lapply(which, function(w) import(file, which = w, ...))
    }
}
