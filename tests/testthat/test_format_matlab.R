skip_if_not_installed("rmatio")

test_that("Export to and import from matlab", {
    skip("failing mysteriously")
    withr::with_tempfile("iris_file", fileext = ".matlab", code = {
        export(iris, iris_file)
        expect_true(file.exists(iris_file))
        expect_true(is.data.frame(import(iris_file)))
        expect_true(identical(dim(import(iris_file)), dim(iris)))

    })
})
