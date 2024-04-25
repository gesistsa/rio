test_that("External read functions without an import method", {
    extensions <- c("bib", "bmp", "gexf", "gnumeric", "jpeg", "jpg", "npy", "png", "sss", "sdmx", "tiff")
    for (ext in extensions) {
        withr::with_tempfile("dummyfile", fileext = paste0(".", ext), code = {
            file.create(dummyfile)
            expect_error(import(dummyfile))
        })
    }
})

test_that("import method exported by an external package", {
    extensions <- c("bean", "beancount", "ledger", "hledger")
    for (ext in extensions) {
        withr::with_tempfile("dummyfile", fileext = paste0(".", ext), code = {
            file.create(dummyfile)
            expect_error(import(dummyfile))
        })
    }
})
