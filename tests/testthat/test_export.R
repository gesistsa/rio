context("Exports")
require("datasets")

test_that("Export to TSV", {
    expect_true(export(iris, "iris.tsv") %in% dir())
    unlink("iris.tsv")
})
test_that("Export to CSV", {
    expect_true(export(iris, "iris.csv") %in% dir())
    unlink("iris.csv")
})
test_that("Export to PSV", {
    expect_true(export(iris, "iris.psv") %in% dir())
    unlink("iris.psv")
})
test_that("Export to FWF", {
    expect_true(export(iris, "iris.fwf") %in% dir())
    unlink("iris.fwf")
})
test_that("Export to RDS", {
    expect_true(export(iris, "iris.RDS") %in% dir())
    unlink("iris.RDS")
})
test_that("Export to RDATA", {
    expect_true(export(iris, "iris.Rdata") %in% dir())
    unlink("iris.Rdata")
})
test_that("Export to JSON", {
    expect_true(export(iris, "iris.json") %in% dir())
    unlink("iris.json")
})
test_that("Export to Stata", {
    expect_true(export(iris, "iris.dta") %in% dir())
    unlink("iris.dta")
})
test_that("Export to SPSS (.sav)", {
    expect_true(export(iris, "iris.sav") %in% dir())
    unlink("iris.sav")
})
test_that("Export to XBASE", {
    expect_true(export(iris, "iris.dbf") %in% dir())
    unlink("iris.dbf")
})
#test_that("Export to Excel (.xls)", {})
test_that("Export to Excel (.xlsx)", {
    expect_true(export(iris, "iris.xlsx") %in% dir())
    unlink("iris.xlsx")
})
test_that("Export to Weka", {
    expect_true(export(iris, "iris.arff") %in% dir())
    unlink("iris.arff")
})
test_that("Export to .R dump file", {
    expect_true(export(iris, "iris.R") %in% dir())
    unlink("iris.R")
})
test_that("Export to XML", {
    expect_true(export(iris, "iris.xml") %in% dir())
    unlink("iris.xml")
})
