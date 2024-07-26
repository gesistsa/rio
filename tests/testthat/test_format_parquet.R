skip_if_not_installed("nanoparquet")
skip_on_os("mac") ## apache/arrow#40991

test_that("Export to and import from parquet", {
    withr::with_tempfile("iris_path", fileext = ".parquet", code = {
        export(iris, iris_path)
        expect_true(file.exists(iris_path))
        expect_true(is.data.frame(import(iris_path)))
    })
})
