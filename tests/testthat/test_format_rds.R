context("RDS imports/exports")
require("datasets")

test_that("Export to RDS", {
    expect_true(export(iris, "iris.RDS") %in% dir())
})

test_that("Import from RDS", {
    expect_true(is.data.frame(import("iris.RDS")))
})

unlink("iris.RDS")
