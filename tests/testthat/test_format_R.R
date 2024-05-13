require("datasets")

test_that("Export / Import to .R dump file", {
    withr::with_tempfile("iris_file", fileext = ".R", code = {
        export(iris, iris_file)
        expect_true(file.exists(iris_file))
        expect_true(is.data.frame(import(iris_file)))

    })
    withr::with_tempfile("iris_file", fileext = ".dump", code = {
        export(iris, iris_file)
        expect_true(file.exists(iris_file))
        expect_true(is.data.frame(import(iris_file)))
    })
})

test_that("Deprecation of untrusted dump", {
    withr::with_tempfile("iris_file", fileext = ".dump", code = {
      export(iris, iris_file)
      ## expect deprecation to work
      lifecycle::expect_deprecated(import(iris_file), regexp = "set to FALSE by default")
      ## expect false to error
      expect_error(import(iris_file, trust = FALSE))
  })
})
