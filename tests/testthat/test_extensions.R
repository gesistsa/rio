library("datasets")
skip_on_cran()

test_that("S3 extension mechanism works for imports", {
    withr::with_tempdir({
        write.csv(iris, "iris.custom")
        expect_error(import("iris.custom"), "Format not supported")
        .import.rio_custom <- function(file, ...) {
            read.csv(file, ...)
        }
        expect_error(.import.rio_custom("iris.custom"), NA)
        assign(".import.rio_custom", .import.rio_custom, envir = .GlobalEnv)
        expect_true(is.data.frame(import("iris.custom")))
        rm(list = ".import.rio_custom", envir = .GlobalEnv)
    })
})

test_that("S3 extension mechanism works for exports", {
    withr::with_tempdir({
        expect_error(export(iris, "iris.custom"))
        .export.rio_custom <- function(file, x, ...) {
            write.csv(x, file, ...)
            invisible(file)
        }
        expect_error(.export.rio_custom("iris.custom", iris), NA)
        assign(".export.rio_custom", .export.rio_custom, envir = .GlobalEnv)
        expect_true(is.character(export(iris, "iris.custom")))
        rm(list = ".export.rio_custom", envir = .GlobalEnv)
    })
})
