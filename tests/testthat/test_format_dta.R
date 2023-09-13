context("Stata (.dta) imports/exports")
require("datasets")

test_that("Export to Stata", {
    expect_true(export(mtcars, "mtcars.dta") %in% dir())
    mtcars3 <- mtcars
    names(mtcars3)[1] <- "foo.bar"
    expect_error(export(mtcars3, "mtcars3.dta"), label = "Export fails on invalid Stata names")
})

test_that("Import from Stata (read_dta)", {
    expect_true(is.data.frame(import("mtcars.dta")))
    # arguments ignored
    expect_error(import("mtcars.dta", extraneous.argument = TRUE), NA)
    expect_silent(import("mtcars.dta",
        extraneous.argument = TRUE
    ))
})

test_that("Import from Stata with extended Haven features (read_dta)", {
    expect_true(is.data.frame(mtcars_wtam <- import("mtcars.dta",
        col_select = c("wt", "am"),
        n_max = 10
    )))
    expect_identical(c(10L, 2L), dim(mtcars_wtam))
    expect_identical(c("wt", "am"), names(mtcars_wtam))
})

test_that("haven is deprecated", {
    lifecycle::expect_deprecated(import("mtcars.dta", haven = TRUE))
    lifecycle::expect_deprecated(import("mtcars.dta", haven = FALSE))
})

unlink("mtcars.dta")
unlink("mtcars3.dta")
