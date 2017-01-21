context("Rdata imports/exports")
require("datasets")

test_that("Export to Rdata", {
    expect_true(export(iris, "iris.Rdata") %in% dir())
})

test_that("Import from Rdata", {
    expect_true(is.data.frame(import("iris.Rdata")))
    expect_true(is.data.frame(import("iris.Rdata", which = 1)))
})

test_that("Export to rda", {
    expect_true(export(iris, "iris.rda") %in% dir())
})

test_that("Import from rda", {
    expect_true(is.data.frame(import("iris.rda")))
    expect_true(is.data.frame(import("iris.rda", which = 1)))
})

unlink("iris.Rdata")
unlink("iris.rda")
