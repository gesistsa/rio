skip_if_not_installed(pkg="fst")

test_that("Export to and import from fst", {
    withr::with_tempfile("iris_file", fileext = ".fst", code = {
        export(iris, iris_file)
        expect_true(file.exists(iris_file))
        expect_true(is.data.frame(import(iris_file)))
    })
})
