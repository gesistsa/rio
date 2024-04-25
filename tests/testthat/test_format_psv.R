test_that("Export to and import from PSV", {
    withr::with_tempfile("iris_file", fileext = ".psv", code = {
        export(iris, iris_file)
        expect_true(file.exists(iris_file))
        expect_true(is.data.frame(import(iris_file)))
    })
})


test_that("fread is deprecated", {
    withr::with_tempfile("iris_file", fileext = ".psv", code = {
        export(iris, iris_file)
        lifecycle::expect_deprecated(import(iris_file, fread = TRUE))
        lifecycle::expect_deprecated(import(iris_file, fread = FALSE))
    })

})
