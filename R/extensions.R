## @rdname extensions
## @aliases extensions .import .export
## @title rio Extensions
## @description Writing Import/Export Extensions for rio
## @param file A character string naming a file.
## @param x A data frame or matrix to be written into a file.
## @param \dots Additional arguments passed to methods.
## @return For \code{.import}, an R data.frame. For \code{.export}, \code{file}, invisibly.
## @details rio implements format-specific S3 methods for each type of file that can be imported from or exported to. This happens via internal S3 generics, \code{.import} and \code{.export}. It is possible to write new methods like with any S3 generic (e.g., \code{print}).
##
## As an example, \code{.import.rio_csv} imports from a comma-separated values file. If you want to produce a method for a new filetype with extension \dQuote{myfile}, you simply have to create a function called \code{.import.rio_myfile} that implements a format-specific importing routine and returns a data.frame. rio will automatically recognize new S3 methods, so that you can then import your file using: \code{import("file.myfile")}.
##
## As general guidance, if an import method creates many attributes, these attributes should be stored --- to the extent possible --- in variable-level attributes fields. These can be \dQuote{gathered} to the data.frame level by the user via \code{\link{gather_attrs}}.
## @seealso \code{\link{import}}, \code{\link{export}}
.import <- function(file, ...) {
    UseMethod(".import")
}

## @rdname extensions
.import.default <- function(file, ...) {
    x <- gettext("%s format not supported. Consider using the '%s()' function")
    xA <- gettext("Import support for the %s format is exported by the %s package. Run 'library(%s)' then try again.")
    fmt <- tools::file_ext(file)
    out <- switch(fmt,
        bean = sprintf(xA, fmt, "ledger", "ledger"),
        beancount = sprintf(xA, fmt, "ledger", "ledger"),
        bib = sprintf(x, fmt, "bib2df::bib2df"),
        bmp = sprintf(x, fmt, "bmp::read.bmp"),
        doc = sprintf(x, fmt, "docxtractr::docx_extract_all_tbls"),
        docx = sprintf(x, fmt, "docxtractr::docx_extract_all_tbls"),
        gexf = sprintf(x, fmt, "rgexf::read.gexf"),
        gnumeric = sprintf(x, fmt, "gnumeric::read.gnumeric.sheet"),
        hledger = sprintf(xA, fmt, "ledger", "ledger"),
        jpeg = sprintf(x, fmt, "jpeg::readJPEG"),
        jpg = sprintf(x, fmt, "jpeg::readJPEG"),
        ledger = sprintf(xA, fmt, "ledger", "ledger"),
        npy = sprintf(x, fmt, "RcppCNPy::npyLoad"),
        pdf = sprintf(x, fmt, "tabulizer::extract_tables"),
        png = sprintf(x, fmt, "png::readPNG"),
        sdmx = sprintf(x, fmt, "sdmx::readSDMX"),
        sss = sprintf(x, fmt, "sss::read.sss"),
        tiff = sprintf(x, fmt, "tiff::readTIFF"),
        gettext("Format not supported")
    )
    stop(out, call. = FALSE)
}

## @rdname extensions
.export <- function(file, x, ...) {
    UseMethod(".export")
}

## @rdname extensions
.export.default <- function(file, x, ...) {
    x <- gettext("%s format not supported. Consider using the '%s()' function")
    fmt <- tools::file_ext(file)
    out <- switch(fmt,
        gexf = sprintf(x, fmt, "rgexf::write.gexf"),
        jpg = sprintf(x, fmt, "jpeg::writeJPEG"),
        npy = sprintf(x, fmt, "RcppCNPy::npySave"),
        png = sprintf(x, fmt, "png::writePNG"),
        tiff = sprintf(x, fmt, "tiff::writeTIFF"),
        xpt = sprintf(x, fmt, "SASxport::write.xport"),
        gettext("Format not supported")
    )
    stop(out, call. = FALSE)
}
