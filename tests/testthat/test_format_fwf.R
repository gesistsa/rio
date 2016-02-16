context("FWF imports/exports")
require("datasets")

test_that("Export to FWF", {
    expect_true(export(iris, "iris.fwf") %in% dir())
    expect_true(export(iris, "iris.txt", format = "fwf") %in% dir())
})

test_that("Import from FWF", {
    expect_true(is.data.frame(import("iris.fwf", widths = c(4,4,4,4,1))))
    expect_true(is.data.frame(import("iris.txt", widths = c(4,4,4,4,1), format = "fwf")))
})

unlink("iris.fwf")
unlink("iris.txt")

