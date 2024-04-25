skip_if_not_installed("qs")

test_that("Export to and import from qs", {
    withr::with_tempfile("iris_file", fileext = ".qs", code = {
        export(iris, iris_file)
        expect_true(file.exists(iris_file))
        expect_true(is.data.frame(import(iris_file)))
    })
})
