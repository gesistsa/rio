skip_if_not_installed("yaml")

test_that("Export to and import from YAML", {
    withr::with_tempfile("iris_file", fileext = ".yaml", code = {
        export(iris, iris_file)
        expect_true(file.exists(iris_file))
        expect_true(is.data.frame(import(iris_file)))
        expect_identical(import(iris_file)[, 1:4], iris[, 1:4])
        expect_identical(import(iris_file)$Species, as.character(iris$Species))
    })
})

test_that("utf-8", {
    skip_if(getRversion() <= "4.2")
    withr::with_tempfile("tempyaml", fileext = ".yaml", code = {
        content <- c("\"", "\u010d", "\u0161", "\u00c4", "\u5b57", "\u30a2", "\u30a2\u30e0\u30ed")
        x <- data.frame(col = content)
        y <- import(export(x, tempyaml))
        testthat::expect_equal(content, y$col)
    })
})
