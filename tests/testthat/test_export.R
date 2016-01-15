context("Exports")
require("datasets")

test_that("Export to TSV", {
    expect_true(export(iris, "iris.tsv") %in% dir())
})
test_that("Export to CSV", {
    expect_true(export(iris, "iris.csv") %in% dir())
})
test_that("Export to PSV", {
    expect_true(export(iris, "iris.psv") %in% dir())
})
test_that("Export to FWF", {
    expect_true(export(iris, "iris.fwf") %in% dir())
})
test_that("Export to RDS", {
    expect_true(export(iris, "iris.RDS") %in% dir())
})
test_that("Export to RDATA", {
    expect_true(export(iris, "iris.Rdata") %in% dir())
})
test_that("Export to JSON", {
    expect_true(export(iris, "iris.json") %in% dir())
})
test_that("Export to Stata", {
    expect_true(export(iris, "iris.dta") %in% dir())
})
test_that("Export to SPSS (.sav)", {
    expect_true(export(iris, "iris.sav") %in% dir())
})
test_that("Export to XBASE", {
    expect_true(export(iris, "iris.dbf") %in% dir())
})
#test_that("Export to Excel (.xls)", {})
test_that("Export to Excel (.xlsx)", {
    expect_true(export(iris, "iris.xlsx") %in% dir())
})
test_that("Export to Weka", {
    expect_true(export(iris, "iris.arff") %in% dir())
})
test_that("Export to .R dump file", {
    expect_true(export(iris, "iris.R") %in% dir())
})
test_that("Export to XML", {
    expect_true(export(iris, "iris.xml") %in% dir())
})
