context("FWF imports/exports")
require("datasets")

test_that("Export to FWF", {
    expect_true(export(iris, "iris.fwf") %in% dir())
    expect_true(export(iris, "iris.txt") %in% dir())
})

test_that("Import from FWF", {
    expect_true(is.data.frame(import("iris.fwf")))
    expect_true(is.data.frame(import("iris.txt", format = "fwf")))
})

unlink("iris.fwf")
unlink("iris.txt")

