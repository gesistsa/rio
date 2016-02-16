context("R dump imports/exports")
require("datasets")

test_that("Export to .R dump file", {
    expect_true(export(iris, "iris.R") %in% dir())
})

test_that("Import from .R dump file", {
    expect_true(is.data.frame(import("iris.R")))
})

unlink("iris.R")
