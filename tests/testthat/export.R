context("Exports")
require("datasets")

test_that("Export to TSV", {
    export(iris, "iris.tsv")
})
test_that("Export to CSV", {
    export(iris, "iris.csv")
})
test_that("Export to PSV", {
    export(iris, "iris.psv")
})
test_that("Export to FWF", {
    export(iris, "iris.fwf")
})
test_that("Export to RDS", {
    export(iris, "iris.RDS")
})
test_that("Export to RDATA", {
    export(iris, "iris.Rdata")
})
test_that("Export to JSON", {
    export(iris, "iris.json")
})
test_that("Export to Stata", {
    export(iris, "iris.dta")
})
test_that("Export to SPSS (.sav)", {
    export(iris, "iris.sav")
})
test_that("Export to XBASE", {
    export(iris, "iris.dbf")
})
#test_that("Export to Excel (.xls)", {})
test_that("Export to Excel (.xlsx)", {
    export(iris, "iris.xlsx")
})
test_that("Export to Weka", {
    export(iris, "iris.arff")
})
test_that("Export to .R dump file", {
    export(iris, "iris.R")
})
test_that("Export to XML", {
    export(iris, "iris.xml")
})
