context("XBASE (.dbf) imports/exports")
require("datasets")

test_that("Export to XBASE (.dbf)", {
    expect_true(export(iris, "iris.dbf") %in% dir())
})

test_that("Import from XBASE (.dbf)", {
    d <- import("iris.dbf")
    expect_true(is.data.frame(d))
    expect_true(!"factor" %in% sapply(d, class))
})

unlink("iris.dbf")
