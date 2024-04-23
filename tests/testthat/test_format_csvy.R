test_that("Export to and import from CSVY", {
    withr::with_tempfile("iris_file", fileext = ".csvy", code = {
        suppressWarnings(export(iris, iris_file))
        expect_true(file.exists(export(iris, iris_file)))
        suppressWarnings(d <- import(iris_file))
        expect_true(is.data.frame(d))
    })
})
