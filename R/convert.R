#' @title Convert from one file format to another
#' @description This function constructs a data frame from a data file using [import()] and uses [export()] to write the data to disk in the format indicated by the file extension.
#' @param in_file A character string naming an input file.
#' @param out_file A character string naming an output file.
#' @param in_opts A named list of options to be passed to [import()].
#' @param out_opts A named list of options to be passed to [export()].
#' @return A character string containing the name of the output file (invisibly).
#' @examples
#' # create a file to convert
#' ## For demo, a temp. file path is created with the file extension .dta (Stata)
#' dta_file <- tempfile(fileext = ".dta")
#' ## .csv
#' csv_file <- tempfile(fileext = ".csv")
#' ## .xlsx
#' xlsx_file <- tempfile(fileext = ".xlsx")
#'
#'
#' ## Create a Stata data file
#' export(mtcars, dta_file)
#'
#' ## convert Stata to CSV and open converted file
#' convert(dta_file, csv_file)
#' import(csv_file)
#'
#' ## correct an erroneous file format
#' export(mtcars, xlsx_file, format = "tsv") ## DON'T DO THIS
#' ## import(xlsx_file) ## ERROR
#' ## convert the file by specifying `in_opts`
#' convert(xlsx_file, xlsx_file, in_opts = list(format = "tsv"))
#' import(xlsx_file)
#'
#' ## convert from the command line:
#' ## Rscript -e "rio::convert('mtcars.dta', 'mtcars.csv')"
#' @seealso [Luca Braglia](https://lbraglia.github.io/) has created a Shiny app called [rioweb](https://github.com/lbraglia/rioweb) that provides access to the file conversion features of rio through a web browser.
#' @export
convert <- function(in_file, out_file, in_opts=list(), out_opts=list()) {
    if (missing(out_file)) {
        stop("'outfile' is missing with no default")
    }
    invisible(do.call("export", c(list(file = out_file, x = do.call("import", c(list(file=in_file), in_opts))), out_opts)))
}
