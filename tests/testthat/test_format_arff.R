test_that("Weka (.arff) imports/exports", {
    withr::with_tempfile("iris_file", fileext = ".arff", code = {
        export(iris, iris_file)
        expect_true(file.exists(iris_file))
        expect_true(is.data.frame(import(iris_file)))
    })
})
