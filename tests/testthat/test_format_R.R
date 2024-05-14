require("datasets")

test_that("Export / Import to .R dump file", {
    withr::with_tempfile("iris_file", fileext = ".R", code = {
        export(iris, iris_file)
        expect_true(file.exists(iris_file))
        expect_true(is.data.frame(import(iris_file, trust = TRUE)))

    })
    withr::with_tempfile("iris_file", fileext = ".dump", code = {
        export(iris, iris_file)
        expect_true(file.exists(iris_file))
        expect_true(is.data.frame(import(iris_file, trust = TRUE)))
    })
})
