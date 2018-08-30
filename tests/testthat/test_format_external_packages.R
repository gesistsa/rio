context("External package support Import/Export")
require("datasets")


extensions <- c("bib", "bmp", "gexf", "gnumeric", "jpeg", "jpg", "npy", "png", "sss", "sdmx", "tiff")
read_fn <- function(ext) {
    switch(ext,
          bib = "bib2df::bib2df",
          bmp = "bmp::read.bmp",
          gexf = "rgexf::read.gexf",
          gnumeric = "gnumeric::read.gnumeric.sheet",
          jpeg = "jpeg::readJPEG",
          jpg = "jpeg::readJPEG",
          npy = "RcppCNPy::npyLoad",
          png = "png::readPNG",
          sdmx = "sdmx::readSDMX",
          sss = "sss::read.sss",
          tiff = "tiff::readTIFF")
}

test_that("External read functions without an import method", {
    message <- "%s format not supported. Consider using the '%s()' function"
    for (ext in extensions) {
        file <- file.path(tempdir(), paste0("test.", ext))
        file.create(file)
        on.exit(unlink(file))
        expect_error(import(file), sprintf(message, ext, read_fn(ext)), fixed=TRUE)
    }
})

i_extensions <- c("bean", "beancount", "ledger", "hledger")
i_package_fn <- function(ext) {
    switch(ext,
        bean = "ledger",
        beancount = "ledger",
        ledger = "ledger",
        hledger = "ledger")
}

test_that("External import functions", {
    message <- paste("Import support for the %s format is exported by the %s package.",
                           "Run 'library(%s)' then try again.")
    for (ext in i_extensions) {
        file <- file.path(tempdir(), paste0("test.", ext))
        file.create(file)
        on.exit(unlink(file))
        package <- i_package_fn(ext)
        expect_error(import(file), sprintf(message, ext, package, package), fixed=TRUE)
    }
})

