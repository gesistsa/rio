context("Stata (.dta) imports/exports")
require("datasets")

test_that("Export to Stata", {
    expect_true(export(mtcars, "mtcars.dta") %in% dir())
    expect_error(export(iris, "iris.dta"), label = "Export fails on invalid Stata names")
})

test_that("Import from Stata (read_dta)", {
    expect_true(is.data.frame(import("mtcars.dta", haven = TRUE)))
    # arguments ignored
    expect_warning(is.data.frame(import("mtcars.dta", haven = TRUE, extraneous.argument = TRUE)))
})

test_that("Import from Stata (read.dta)", {
    expect_true(is.data.frame(import("mtcars.dta", haven = FALSE)))
})

unlink("mtcars.dta")
unlink("iris.dta")
