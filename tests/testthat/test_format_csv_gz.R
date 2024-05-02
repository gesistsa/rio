test_that("Export to and import from csv.gz", {
    withr::with_tempfile("iris_file", fileext = ".csv.gz", code = {
        export(iris, iris_file)
        expect_true(file.exists(iris_file))
        expect_true(R.utils::isGzipped(iris_file, method = "content"))
        expect_true(is.data.frame(import(iris_file)))
    })
})

test_that("Not support other gz format export for now ref #399", {
    withr::with_tempfile("iris_file", fileext = ".sav.gz", code = {
        expect_error(export(iris, iris_file), "gz is only supported for csv")
        expect_false(file.exists(iris_file))
    })
})

test_that("Not support other gz format import for now ref #399", {
    withr::with_tempfile("iris_file", fileext = ".sav", code = {
        export(iris, iris_file)
        ## compress it
        R.utils::gzip(iris_file, overwrite = TRUE)
        expect_true(file.exists(paste0(iris_file, ".gz")))
        expect_true(R.utils::isGzipped(paste0(iris_file, ".gz"), method = "content"))
        expect_error(import(paste0(iris_file, ".gz")))
    })
})
