context("Convert")
library("datasets")

export(mtcars, "mtcars.dta")

test_that("Basic file conversion", {
    convert("mtcars.dta", "mtcars.csv")
    convert("mtcars.csv", "mtcars.dta")
    x <- import("mtcars.dta")
    expect_true(identical(names(mtcars), names(x)))
    expect_true(identical(dim(mtcars), dim(x)))
    unlink("mtcars.csv")
})

test_that("File conversion with arguments", {
    export(mtcars, "mtcars.csv", format = "tsv")
    convert("mtcars.csv", "mtcars.csv", in_opts = list(format = "tsv"))
    expect_true("mtcars.csv" %in% dir())
    expect_true(!("mtcars.tsv" %in% dir()))
    convert("mtcars.csv", "mtcars.tsv",
            in_opts = list(format = "tsv"), out_opts = list(format = "csv"))
    expect_true("mtcars.tsv" %in% dir())
    unlink("mtcars.csv")
    unlink("mtcars.tsv")
})

test_that("File conversion w/o out_file errors", {
    expect_error(convert("mtcars.dta"))
})

unlink("mtcars.dta")
