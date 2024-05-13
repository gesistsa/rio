test_that("Deprecation of untrusted dump", {
    withr::with_tempfile("iris_file", fileext = ".dump", code = {
      export(iris, iris_file)
      ## expect deprecation to work
      lifecycle::expect_deprecated(import(iris_file), regexp = "set to FALSE by default")
      ## expect false to error
      expect_error(import(iris_file, trust = FALSE))
  })
})

test_that("Deprecation of untrusted Rdata", {
    withr::with_tempfile("iris_file", fileext = ".Rdata", code = {
        export(iris, iris_file)
        ## expect deprecation to work
        lifecycle::expect_deprecated(import(iris_file), regexp = "set to FALSE by default")
        ## expect false to error
        expect_error(import(iris_file, trust = FALSE))
    })
})

test_that("Deprecation of untrusted rds", {
    withr::with_tempfile("iris_file", fileext = ".rds", code = {
      export(iris, iris_file)
      ## expect deprecation to work
      lifecycle::expect_deprecated(import(iris_file), regexp = "set to FALSE by default")
      ## expect false to error
      expect_error(import(iris_file, trust = FALSE))
  })
})

test_that("No deprecation warning if `trust` is explicit", {
    withr::with_tempfile("iris_file", fileext = ".rds", code = {
        export(iris, iris_file)
        expect_silent(import(iris_file, trust = TRUE))
        expect_error(import(iris_file, trust = FALSE)) ## no warning right?
    })
})

test_that("Undocumented feature, options", {
    withr::with_options(list(rio.import.trust = TRUE), {
        withr::with_tempfile("iris_file", fileext = ".rds", code = {
            export(iris, iris_file)
            expect_silent(import(iris_file))
            expect_error(import(iris_file), NA)
        })
    })
    withr::with_options(list(rio.import.trust = FALSE), {
        withr::with_tempfile("iris_file", fileext = ".rds", code = {
            export(iris, iris_file)
            expect_error(import(iris_file))
        })
    })
})

test_that("`trust` wont cause problems for other import methods", {
    withr::with_tempfile("iris_file", fileext = ".xlsx", code = {
        export(iris, iris_file)
        expect_silent(import(iris_file, trust = TRUE))
        expect_error(import(iris_file, trust = FALSE), NA)
    })
})
