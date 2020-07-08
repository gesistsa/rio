context("Stata (.dta) imports/exports")
require("datasets")

test_that("Export to Stata", {
    expect_true(export(mtcars, "mtcars.dta") %in% dir())
    mtcars3 <- mtcars
    names(mtcars3)[1] <- "foo.bar"
    expect_error(export(mtcars3, "mtcars3.dta"), label = "Export fails on invalid Stata names")
})

test_that("Import from Stata (read_dta)", {
    expect_true(is.data.frame(import("mtcars.dta", haven = TRUE)))
    # arguments ignored
    expect_warning(is.data.frame(import("mtcars.dta", haven = TRUE, extraneous.argument = TRUE)))
})

test_that("Import from Stata (read.dta)", {
    expect_true(is.data.frame(import("http://www.stata-press.com/data/r12/auto.dta", haven = FALSE)))
    expect_error(is.data.frame(import("mtcars.dta", haven = FALSE)), label = "foreign::read.dta cannot read newer Stata files")
})

unlink("mtcars.dta")
