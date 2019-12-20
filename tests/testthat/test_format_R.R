context("R dump imports/exports")
require("datasets")

test_that("Export to .R dump file", {
    expect_true(export(iris, "iris.R") %in% dir())
    expect_true(export(iris, "iris.dump") %in% dir())
})

test_that("Import from .R dump file", {
    expect_true(is.data.frame(import("iris.R")))
    expect_true(is.data.frame(import("iris.dump")))
})

unlink("iris.R")
unlink("iris.dump")
