skip_if_not_installed("jsonlite")

test_that("Export to and import from JSON", {
    withr::with_tempfile("iris_file", fileext = ".json", code = {
        export(iris, iris_file)
        expect_true(file.exists(iris_file))
        expect_true(is.data.frame(import(iris_file)))
    })
})

test_that("Export to JSON (non-data frame)", {
    withr::with_tempfile("list_file", fileext = ".json", code = {
        export(list(1:10, letters), list_file)
        expect_true(file.exists(list_file))
        expect_true(inherits(import(list_file), "list"))
        expect_false(inherits(import(list_file), "data.frame"))
        expect_true(length(import(list_file)) == 2L)
    })
})

test_that("utf-8", {
    content <- c("\"", "\u010d", "\u0161", "\u00c4", "\u5b57", "\u30a2", "\u30a2\u30e0\u30ed")
    x <- data.frame(col = content)
    withr::with_tempfile("tempjson", fileext = ".json", code = {
        y <- import(export(x, tempjson))
        testthat::expect_equal(content, y$col)
    })
})
