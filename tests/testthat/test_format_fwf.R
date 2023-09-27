context("FWF imports/exports")
require("datasets")

test_that("Export to FWF", {
    expect_true(export(iris, "iris.fwf") %in% dir())
    expect_true(export(iris, "iris.txt", format = "fwf") %in% dir())
})

test_that("Deprecation of `width` and `col.names`", {
    lifecycle::expect_deprecated(import("iris.fwf", widths = c(-3, 3, 3, 3, 1)))
    lifecycle::expect_deprecated(import("iris.fwf", col.names = names(iris)))
})

simport <- function(...) {
    suppressWarnings(import(...))
}

test_that("Import from FWF (read.fwf)", {
    expect_true(is.data.frame(simport("iris.fwf", widths = c(3, 3, 3, 3, 1))))
    expect_true(is.data.frame(simport("iris.fwf", widths = list(c(3, 3, 3, 3, 1)))))
    expect_true(is.data.frame(simport("iris.fwf", widths = c(3, 3, 3, 3, 1), col.names = names(iris))))
    expect_true(is.data.frame(simport("iris.txt", widths = c(3, 3, 3, 3, 1), format = "fwf")))
    # negative column widths
    expect_true(is.data.frame(simport("iris.fwf", widths = c(-3, 3, 3, 3, 1))))
})

test_that("use col_position instead", {
    expect_error(x <- import("iris.fwf", col_position = readr::fwf_widths(c(1, 3, 3, 3, 1), col_names = names(iris))), NA)
    expect_equal(x[1,1, drop = TRUE], 5)
})

unlink("iris.fwf")
unlink("iris.txt")
