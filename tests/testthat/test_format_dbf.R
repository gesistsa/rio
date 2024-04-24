test_that("Export to and import from XBASE (.dbf)", {
    skip_if_not_installed("foreign")
    withr::with_tempfile("iris_file", fileext = ".dbf", code = {
        export(iris, iris_file)
        expect_true(file.exists(iris_file))
        d <- import(iris_file)
        expect_true(is.data.frame(d))
        expect_true(!"factor" %in% vapply(d, class, character(1)))
    })
})
