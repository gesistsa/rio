simport <- function(...) {
    suppressWarnings(import(...))
}

test_that("Export to and import from FWF .fwf", {
    withr::with_tempfile("iris_file", fileext = ".fwf", code = {
        export(iris, iris_file)
        expect_true(file.exists(iris_file))
        expect_true(is.data.frame(simport(iris_file, widths = c(3, 3, 3, 3, 1))))
        expect_true(is.data.frame(simport(iris_file, widths = list(c(3, 3, 3, 3, 1)))))
        expect_true(is.data.frame(simport(iris_file, widths = c(3, 3, 3, 3, 1), col.names = names(iris))))
        ## negative column widths
        expect_true(is.data.frame(simport(iris_file, widths = c(-3, 3, 3, 3, 1))))
        ##use col_position instead
        expect_error(x <- import(iris_file, col_position = readr::fwf_widths(c(1, 3, 3, 3, 1), col_names = names(iris))), NA)
        expect_equal(x[1,1, drop = TRUE], 5)
    })
})

test_that("Export to and import from FWF .txt", {
    withr::with_tempfile("iris_file", fileext = ".txt", code = {
        export(iris, iris_file)
        expect_true(file.exists(iris_file))
        expect_true(is.data.frame(simport(iris_file, widths = c(3, 3, 3, 3, 1), format = "fwf")))
    })
})

test_that("Deprecation of `width` and `col.names`", {
    withr::with_tempfile("iris_file", fileext = ".fwf", code = {
        export(iris, iris_file)
        lifecycle::expect_deprecated(import(iris_file, widths = c(-3, 3, 3, 3, 1)))
        lifecycle::expect_deprecated(import(iris_file, col.names = names(iris)))
    })
})
