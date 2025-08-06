skip_if_not_installed("qs2")

test_that("Export to and import from qs2", {
    withr::with_tempfile("iris_file", fileext = ".qs2", code = {
        export(iris, iris_file)
        expect_true(file.exists(iris_file))
        expect_true(is.data.frame(import(iris_file)))
    })
})
