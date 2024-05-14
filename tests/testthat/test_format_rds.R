test_that("Export to and import from rds", {
    withr::with_tempfile("iris_file", fileext = ".rds", code = {
        export(iris, iris_file)
        expect_true(file.exists(iris_file))
        expect_true(is.data.frame(import(iris_file, trust = TRUE)))
    })
})

test_that("Export to rds (non-data frame)", {
    withr::with_tempfile("list_file", fileext = ".rds", code = {
        export(list(1:10, letters), list_file)
        expect_true(file.exists(list_file))
        expect_true(inherits(import(list_file, trust = TRUE), "list"))
        expect_true(length(import(list_file, trust = TRUE)) == 2L)
    })
})
