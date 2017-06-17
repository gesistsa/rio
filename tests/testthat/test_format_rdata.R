context("Rdata imports/exports")
require("datasets")

test_that("Export to Rdata", {
    # data.frame
    expect_true(export(iris, "iris.Rdata") %in% dir())
    # environment
    e <- new.env()
    e$iris <- iris
    expect_true(export(e, "iris.Rdata") %in% dir())
    # character
    expect_true(export("iris", "iris.Rdata") %in% dir())
    # expect error otherwise
    expect_error(export(iris$Species, "iris.Rdata") %in% dir())
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
