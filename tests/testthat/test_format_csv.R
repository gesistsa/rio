context("CSV imports/exports")
require("datasets")

test_that("Export to CSV", {
    expect_true(export(iris, "iris.csv") %in% dir())
    unlink("iris.csv")
})

test_that("Export (Append) to CSV", {
    export(iris, "iris.csv")
    nlines <- length(readLines("iris.csv"))
    export(iris, "iris.csv", append = FALSE)
    expect_true(identical(length(readLines("iris.csv")), nlines))
    export(iris, "iris.csv", append = TRUE)
    expect_true(identical(length(readLines("iris.csv")), (2L*nlines)-1L))
    unlink("iris.csv")
})

test_that("Import from CSV", {
    noheadercsv <- import("../testdata/noheader.csv", header = FALSE)
    expect_that(colnames(noheadercsv)[1], equals("V1"), label = "Header is correctly specified")
})

test_that("Import from (European-style) CSV with semicolon separator", {
    write.table(iris, "iris2.csv", dec = ",", sep = ";", row.names = FALSE)
    expect_true("iris2.csv" %in% dir())
    # import works (even if column classes are incorrect)
    expect_true(is.data.frame(import("iris2.csv", fread = TRUE, header = TRUE)))
    iris_imported <- import("iris2.csv", format = ";", fread = TRUE, header = TRUE)
    # import works with correct, numeric column classes
    expect_true(is.data.frame(iris_imported))
    expect_true(is.numeric(iris_imported[["Sepal.Length"]]))
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
    expect_true(ncol(import("iris.csv", sep = ",")) == 5L) # use `data.table::fread(sep = "auto")` even if `sep` set explicitly to ","
    expect_true(ncol(import("iris.csv", format = "csv")) == 5L)
    expect_true(ncol(import("iris.csv", sep = "auto")) == 5L)
})

unlink("iris.csv")
unlink("iris2.csv")
