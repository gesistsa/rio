library("datasets")

test_that("S3 extension mechanism works for imports", {
    withr::with_tempdir({
        write.csv(iris, "iris.custom")
        expect_error(import("iris.custom"), "Format not supported")
        .import.rio_custom <- function(file, ...) {
            read.csv(file, ...)
        }
        expect_error(.import.rio_custom("iris.custom"), NA)
        ## .import("iris.custom")
        ## expect_true(is.data.frame(import("iris.custom")))
        rm(.import.rio_custom)
    })
})

test_that("S3 extension mechanism works for exports", {
    withr::with_tempdir({
        expect_error(export("iris.custom"))
        .export.rio_custom <- function(file, data, ...) {
            write.csv(data, file, ...)
            invisible(file)
        }
        ## expect_error(is.character(export(iris, "iris.custom")))
        rm(.export.rio_custom)
    })
})
