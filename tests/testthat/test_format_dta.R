context("Stata (.dta) imports/exports")
require("datasets")

test_that("Export to Stata", {
    expect_true(export(iris, "iris.dta") %in% dir())
})

test_that("Import from Stata (read_dta)", {
    expect_true(is.data.frame(import("iris.dta", haven = TRUE)))
})

test_that("Import from Stata (read.dta)", {
    expect_true(is.data.frame(import("iris.dta", haven = FALSE)))
})

unlink("iris.dta")
