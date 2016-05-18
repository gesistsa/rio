context("Rdata imports/exports")
require("datasets")

test_that("Export to Rdata", {
    expect_true(export(iris, "iris.Rdata") %in% dir())
})

test_that("Import from Rdata", {
    expect_true(is.data.frame(import("iris.Rdata")))
    expect_true(is.data.frame(import("iris.Rdata", which = 1)))
})

unlink("iris.Rdata")
