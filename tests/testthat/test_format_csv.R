context("CSV imports/exports")
require("datasets")

test_that("Export to CSV", {
    expect_true(export(iris, "iris.csv") %in% dir())
    unlink("iris.csv")
})

test_that("Import from CSV", {
    noheadercsv <- import(system.file("examples", "noheader.csv", package = "rio"), header = FALSE)
    expect_that(colnames(noheadercsv)[1], equals("V1"), label = "Header is correctly specified")
})

test_that("Import from (European-style) CSV with semicolon separator", {
    write.table(iris, "iris2.csv", dec = ",", sep = ";", row.names = FALSE)
    expect_true("iris2.csv" %in% dir())
    expect_true(is.data.frame(import("iris2.csv", dec = ",", sep = ";", fread = TRUE, header = TRUE)))
    expect_true(is.data.frame(import("iris2.csv", dec = ",", sep = ";", fread = FALSE, header = TRUE)))
})


context("CSV (.csv2) imports/exports")

test_that("Export to CSV", {
    expect_true(export(iris, "iris.csv", format = "csv2") %in% dir())
})

test_that("Import from CSV (read.csv)", {
    expect_true(is.data.frame(import("iris.csv", format = "csv2")))
})

test_that("Import from CSV (fread)", {
    expect_true(is.data.frame(import("iris.csv", format = "csv2", fread = TRUE)))
})

test_that("Export to TSV with CSV extension", {
    expect_true(export(iris, "iris.csv", format = "tsv") %in% dir())
})

test_that("Import from TSV with CSV extension", {
    expect_true(ncol(import("iris.csv")) == 5L)
    expect_true(ncol(import("iris.csv", format = "tsv")) == 5L)
    expect_true(ncol(import("iris.csv", format = "tsv", sep = "\t")) == 5L)
    expect_true(ncol(import("iris.csv", sep = ",")) == 1L)
    expect_true(ncol(import("iris.csv", format = "csv")) == 5L)
    expect_true(ncol(import("iris.csv", sep = "auto")) == 5L)
})

unlink("iris.csv")
unlink("iris2.csv")
