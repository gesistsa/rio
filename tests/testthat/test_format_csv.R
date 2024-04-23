require("datasets")

test_that("Export to CSV", {
    withr::with_tempfile("iris_file", fileext = ".csv", code = {
        export(iris, iris_file)
        expect_true(file.exists(iris_file))
    })
})

test_that("Export (Append) to CSV", {
    withr::with_tempfile("iris_file", fileext = ".csv", code = {
        export(iris, iris_file)
        nlines <- length(readLines(iris_file))
        export(iris, iris_file, append = FALSE)
        expect_true(identical(length(readLines(iris_file)), nlines))
        export(iris, iris_file, append = TRUE)
        expect_true(identical(length(readLines(iris_file)), (2L * nlines) - 1L))
    })
})

test_that("Import from CSV", {
    noheadercsv <- import("../testdata/noheader.csv", header = FALSE)
    expect_that(colnames(noheadercsv)[1], equals("V1"), label = "Header is correctly specified")
})

test_that("Import from (European-style) CSV with semicolon separator", {
    withr::with_tempfile("iris_file", fileext = ".csv", code = {
        write.table(iris, iris_file, dec = ",", sep = ";", row.names = FALSE)
        expect_true(file.exists(iris_file))
        ## import works (even if column classes are incorrect)
        expect_true(is.data.frame(import(iris_file, header = TRUE)))
        iris_imported <- import(iris_file, format = ";", header = TRUE)
        ## import works with correct, numeric column classes
        expect_true(is.data.frame(iris_imported))
        expect_true(is.numeric(iris_imported[["Sepal.Length"]]))
    })
})

test_that("Export to and Import from CSV2", {
    withr::with_tempfile("iris_file", fileext = ".csv", code = {
        export(iris, iris_file, format = "csv2")
        expect_true(file.exists(iris_file))
        expect_true(is.data.frame(import(iris_file, format = "csv2")))
    })
})

test_that("Export to and Import from TSV with CSV extension", {
    withr::with_tempfile("iris_file", fileext = ".csv", code = {
        export(iris, iris_file, format = "tsv")
        expect_true(file.exists(iris_file))
        expect_true(ncol(import(iris_file)) == 5L)
        expect_true(ncol(import(iris_file, format = "tsv")) == 5L)
        expect_true(ncol(import(iris_file, format = "tsv", sep = "\t")) == 5L)
        expect_true(ncol(import(iris_file, sep = ",")) == 5L) # use `data.table::fread(sep = "auto")` even if `sep` set explicitly to ","
        expect_true(ncol(import(iris_file, format = "csv")) == 5L)
        expect_true(ncol(import(iris_file, sep = "auto")) == 5L)
    })
})

test_that("fread is deprecated", {
    withr::with_tempfile("iris_file", fileext = ".csv", code = {
        export(iris, iris_file)
        lifecycle::expect_deprecated(import(iris_file, fread = TRUE))
        lifecycle::expect_deprecated(import(iris_file, fread = FALSE))
    })
})
