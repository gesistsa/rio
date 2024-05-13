test_that("Export to and import from Rdata", {
    withr::with_tempfile("iris_file", fileext = ".Rdata", code = {
        ## data frame
        export(iris, iris_file)
        expect_true(file.exists(iris_file))
        expect_true(is.data.frame(import(iris_file)))
        expect_true(is.data.frame(import(iris_file, which = 1)))
    })
    withr::with_tempfile("iris_file", fileext = ".Rdata", code = {
        ## environment
        e <- new.env()
        e$iris <- iris
        export(e, iris_file)
        expect_true(file.exists(iris_file))
        expect_true(is.data.frame(import(iris_file)))
        expect_true(is.data.frame(import(iris_file, which = 1)))
    })
    withr::with_tempfile("iris_file", fileext = ".Rdata", code = {
        ## character
        export("iris", iris_file)
        expect_true(file.exists(iris_file))
        expect_true(is.data.frame(import(iris_file)))
        expect_true(is.data.frame(import(iris_file, which = 1)))
    })
    withr::with_tempfile("iris_file", fileext = ".Rdata", code = {
        ## expect error otherwise
        expect_error(export(iris$Species, iris_file))
    })
    withr::with_tempfile("iris_file", fileext = ".Rdata", code = {
        export(iris, iris_file)
        ## expect deprecation to work
        lifecycle::expect_deprecated(import(iris_file), regexp = "set to FALSE by default")
        ## expect false to error
        expect_error(import(iris_file, trust = FALSE))
    })
})

test_that("Export to and import from rda", {
    withr::with_tempfile("iris_file", fileext = ".rda", code = {
        ## data frame
        export(iris, iris_file)
        expect_true(file.exists(iris_file))
        expect_true(is.data.frame(import(iris_file)))
        expect_true(is.data.frame(import(iris_file, which = 1)))
    })
    withr::with_tempfile("iris_file", fileext = ".rda", code = {
        ## environment
        e <- new.env()
        e$iris <- iris
        export(e, iris_file)
        expect_true(file.exists(iris_file))
        expect_true(is.data.frame(import(iris_file)))
        expect_true(is.data.frame(import(iris_file, which = 1)))
    })
    withr::with_tempfile("iris_file", fileext = ".rda", code = {
        ## character
        export("iris", iris_file)
        expect_true(file.exists(iris_file))
        expect_true(is.data.frame(import(iris_file)))
        expect_true(is.data.frame(import(iris_file, which = 1)))
    })
    withr::with_tempfile("iris_file", fileext = ".rda", code = {
        ## expect error otherwise
        expect_error(export(iris$Species, iris_file))
    })
})
