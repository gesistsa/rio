context("PSV imports/exports")
require("datasets")

test_that("Export to PSV", {
    expect_true(export(iris, "iris.psv") %in% dir())
})

test_that("Import from TSV", {
    expect_true(is.data.frame(import("iris.psv")))
})

unlink("iris.psv")
