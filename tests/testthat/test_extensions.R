context("Extensions")
library("datasets")

test_that("S3 extension mechanism works for imports", {
    write.csv(iris, 'iris.custom')
    expect_error(import("iris.custom"))
    .import.rio_custom <- function(file, ...){
        read.csv(file, ...)
    }
    #expect_true(is.data.frame(import('iris.custom')))
    rm(.import.rio_custom)
})

test_that("S3 extension mechanism works for exports", {
    expect_error(export("iris.custom"))
    .export.rio_custom <- function(file, data, ...){
        write.csv(data, file, ...)
        invisible(file)
    }
    expect_error(is.character(export(iris, "iris.custom")))
    rm(.export.rio_custom)
})

unlink("iris.custom")
