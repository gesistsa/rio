context("External package Import/Export support")
require("datasets")

test_that("External read functions without an import method", {
    extensions <- c("bib", "bmp", "gexf", "gnumeric", "jpeg", "jpg", "npy", "png", "sss", "sdmx", "tiff")
    for (ext in extensions) {
        file <- file.path(tempdir(), paste0("test.", ext))
        file.create(file)
        on.exit(unlink(file))
        expect_error(import(file))
    }
})

test_that("import method exported by an external package", {
    extensions <- c("bean", "beancount", "ledger", "hledger")
    for (ext in extensions) {
        file <- file.path(tempdir(), paste0("test.", ext))
        file.create(file)
        on.exit(unlink(file))
        expect_error(import(file))
    }
})

