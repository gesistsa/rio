context("CSVY imports/exports")
require("datasets")

tmp <- tempfile(fileext = ".csvy")

test_that("Export to CSVY", {
    suppressWarnings(expect_true(file.exists(export(iris, tmp))))
})

test_that("Import from CSVY", {
    suppressWarnings(d <- import(tmp))
    expect_true(inherits(d, "data.frame"))
})

unlink(tmp)
