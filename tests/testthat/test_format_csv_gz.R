test_that("Export to and import from csv.gz", {
    withr::with_tempfile("iris_file", fileext = ".csv.gz", code = {
        export(iris, iris_file)
        expect_true(file.exists(iris_file))
        expect_true(is.data.frame(import(iris_file)))
    })
})
