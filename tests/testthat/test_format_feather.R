skip_if_not_installed("arrow")

test_that("Export to and import from feather", {
    withr::with_tempfile("iris_file", fileext = ".feather", code = {
        export(iris, iris_file)
        expect_true(file.exists(iris_file))
        expect_true(is.data.frame(import(iris_file)))
    })
})
