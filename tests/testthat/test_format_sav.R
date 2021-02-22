context("SPSS (.sav) imports/exports")
require("datasets")

mtcars2 <- mtcars
# label and value labels
mtcars2[["cyl"]] <- factor(mtcars2[["cyl"]], c(4, 6, 8), c("four", "six", "eight"))
attr(mtcars2[["cyl"]], "label") <- "cylinders"
# value labels only
mtcars2[["am"]] <- factor(mtcars2[["am"]], c(0, 1), c("automatic", "manual"))
# variable label only
attr(mtcars2[["mpg"]], "label") <- "miles per gallon"

test_that("Export to SPSS (.sav)", {
    expect_true(export(mtcars2, "mtcars.sav") %in% dir())
})

test_that("Export to SPSS compressed (.zsav)", {
    expect_true(export(mtcars2, "mtcars.zsav") %in% dir())
})

#test_that("Import from SPSS (.sav; read.spss)", {
#    expect_true(is.data.frame(import("mtcars2.sav", haven = FALSE)))
#})

test_that("Import from SPSS (.sav; read_sav)", {
    expect_true(d <- is.data.frame(import("mtcars.sav", haven = TRUE)))
    expect_true(!"labelled" %in% unlist(lapply(d, class)))
    rm(d)
})

test_that("Import from SPSS (.zsav; read_sav)", {
    expect_true(d <- is.data.frame(import("mtcars.zsav")))
    expect_true(!"labelled" %in% unlist(lapply(d, class)))
    rm(d)
})

test_that("Variable label and value labels preserved on SPSS (.sav) roundtrip", {
    d <- import("mtcars.sav")
    a_cyl <- attributes(d[["cyl"]])
    expect_true("label" %in% names(a_cyl))
    expect_true("labels" %in% names(a_cyl))
    expect_true(identical(a_cyl[["label"]], "cylinders"))
    expect_true(identical(a_cyl[["labels"]], stats::setNames(c(1.0, 2.0, 3.0), c("four", "six", "eight"))))

    a_am <- attributes(d[["am"]])
    expect_true("labels" %in% names(a_am))
    expect_true(identical(a_am[["labels"]], stats::setNames(c(1.0, 2.0), c("automatic", "manual"))))

    a_mpg <- attributes(d[["mpg"]])
    expect_true("label" %in% names(a_mpg))
    expect_true(identical(a_mpg[["label"]], "miles per gallon"))
})

test_that("Variable label and value labels preserved on SPSS compressed (.zsav) roundtrip", {
    d <- import("mtcars.zsav")
    a_cyl <- attributes(d[["cyl"]])
    expect_true("label" %in% names(a_cyl))
    expect_true("labels" %in% names(a_cyl))
    expect_true(identical(a_cyl[["label"]], "cylinders"))
    expect_true(identical(a_cyl[["labels"]], stats::setNames(c(1.0, 2.0, 3.0), c("four", "six", "eight"))))

    a_am <- attributes(d[["am"]])
    expect_true("labels" %in% names(a_am))
    expect_true(identical(a_am[["labels"]], stats::setNames(c(1.0, 2.0), c("automatic", "manual"))))

    a_mpg <- attributes(d[["mpg"]])
    expect_true("label" %in% names(a_mpg))
    expect_true(identical(a_mpg[["label"]], "miles per gallon"))
})

unlink("mtcars.sav")
unlink("mtcars.zsav")