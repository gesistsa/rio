#' @title Convert from one file format to another
#' @description This function constructs a data frame from a data file using \code{\link{import}} and uses \code{\link{export}} to write the data to disk in the format indicated by the file extension.
#' @param in_file A character string naming an input file.
#' @param out_file A character string naming an output file.
#' @param in_opts A named list of options to be passed to \code{\link{import}}.
#' @param out_opts A named list of options to be passed to \code{\link{export}}.
#' @return A character string containing the name of the output file (invisibly).
#' @examples
#' # create a file to convert
#' export(mtcars, "mtcars.dta")
#' 
#' # convert Stata to CSV and open converted file
#' convert("mtcars.dta", "mtcars.csv")
#' head(import("mtcars.csv"))
#' 
#' # correct an erroneous file format
#' export(mtcars, "mtcars.csv", format = "tsv")
#' convert("mtcars.csv", "mtcars.csv", in_opts = list(format = "tsv"))
#' 
#' # convert serialized R data.frame to JSON
#' export(mtcars, "mtcars.rds")
#' convert("mtcars.rds", "mtcars.json")
#' 
#' # cleanup
#' unlink("mtcars.csv")
#' unlink("mtcars.dta")
#' unlink("mtcars.rds")
#' unlink("mtcars.json")
#' 
#' \dontrun{
#' # convert from the command line:
#' \code{Rscript -e "rio::convert('mtcars.dta', 'mtcars.csv')"}
#' }
#' 
#' @seealso \href{https://lbraglia.github.io/}{Luca Braglia} has created a Shiny app called \href{https://github.com/lbraglia/rioweb}{rioweb} that provides access to the file conversion features of rio through a web browser. The app is featured in the \href{https://gallery.shinyapps.io/rioweb}{RStudio Shiny Gallery}.
#' @export
convert <- function(in_file, out_file, in_opts=list(), out_opts=list()) {
    if (missing(out_file)) {
        stop("'outfile' is missing with no default")
    }
    invisible(do.call("export", c(list(file = out_file, x = do.call("import", c(list(file=in_file), in_opts))), out_opts)))
}
