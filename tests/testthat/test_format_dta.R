context("Stata (.dta) imports/exports")
require("datasets")

test_that("Export to Stata", {
    expect_true(export(iris, "iris.dta") %in% dir())
})

test_that("Import from Stata", {
    expect_true(is.data.frame(import("iris.dta")))
})

unlink("iris.dta")
