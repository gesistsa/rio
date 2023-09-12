context("FWF imports/exports")
require("datasets")

test_that("Export to FWF", {
    expect_true(export(iris, "iris.fwf") %in% dir())
    expect_true(export(iris, "iris.txt", format = "fwf") %in% dir())
})

test_that("Import from FWF (read.fwf)", {
    expect_true(is.data.frame(import("iris.fwf", widths = c(3, 3, 3, 3, 1))))
    expect_true(is.data.frame(import("iris.fwf", widths = list(c(3, 3, 3, 3, 1)))))
    expect_true(is.data.frame(import("iris.fwf", widths = c(3, 3, 3, 3, 1), col.names = names(iris))))
    expect_true(is.data.frame(import("iris.txt", widths = c(3, 3, 3, 3, 1), format = "fwf")))
    # negative column widths
    expect_true(is.data.frame(import("iris.fwf", widths = c(-3, 3, 3, 3, 1))))
})

test_that("Import from FWF Errors", {
    expect_error(import("iris.fwf"),
        "Import of fixed-width format data requires a 'widths' argument. See ? read.fwf().",
        fixed = TRUE
    )
    # error on NULL widths
    expect_error(import("iris.fwf", widths = NULL))
    # no error on NULL widths w/ readr::read_fwf()
    expect_true(suppressWarnings(is.data.frame(import("iris.fwf", widths = NULL))))
})

unlink("iris.fwf")
unlink("iris.txt")
