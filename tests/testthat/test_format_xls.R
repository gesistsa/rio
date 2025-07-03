test_that("Export to Excel (.xlsx)", {
    withr::with_tempfile("iris_file", fileext = ".xlsx", code = {
        export(iris, iris_file)
        expect_true(file.exists(iris_file))
        expect_true(is.data.frame(import(iris_file)))
        expect_true(is.data.frame(import(iris_file, sheet = 1)))
        expect_true(is.data.frame(import(iris_file, which = 1)))
        expect_true(nrow(import(iris_file, n_max = 42)) == 42)
    })
})

test_that("Expert to Excel (.xlsx) a list", {
    withr::with_tempfile("tempxlsx", fileext = ".xlsx", code = {
        export(list(
            mtcars3 = mtcars[1:10, ],
            mtcars2 = mtcars[11:20, ],
            mtcars1 = mtcars[21:32, ]
        ), tempxlsx)
        expect_equal(readxl::excel_sheets(tempxlsx), c("mtcars3", "mtcars2", "mtcars1"))
    })
})

test_that("Is `sheet` passed?", {
    withr::with_tempfile("tempxlsx", fileext = ".xlsx", code = {
        export(list(
            mtcars3 = mtcars[1:10, ],
            mtcars2 = mtcars[11:20, ],
            mtcars1 = mtcars[21:32, ]
        ), tempxlsx)
        expect_equal(readxl::excel_sheets(tempxlsx), c("mtcars3", "mtcars2", "mtcars1"))
        content <- import(tempxlsx, sheet = "mtcars2")
        expect_equal(content$mpg, mtcars[11:20, ]$mpg)
        content <- import(tempxlsx, which = 2)
        expect_equal(content$mpg, mtcars[11:20, ]$mpg)
    })
})


test_that("readxl is deprecated", {
    withr::with_tempfile("iris_file", fileext = ".xlsx", code = {
        export(iris, iris_file)
        lifecycle::expect_deprecated(import(iris_file, readxl = TRUE))
        lifecycle::expect_deprecated(import(iris_file, readxl = FALSE))
    })
})

test_that("Import from Excel (.xls)", {
    expect_true(is.data.frame(import("../testdata/iris.xls")))
    expect_true(is.data.frame(import("../testdata/iris.xls", sheet = 1)))
    expect_true(is.data.frame(import("../testdata/iris.xls", which = 1)))
})

test_that("Import from Excel (.xlsm)", {
  expect_true(is.data.frame(import("../testdata/example.xlsm", sheet = 1, format = "xlsx")))
  expect_true(is.data.frame(import("../testdata/example.xlsm", which = 1, format = "xlsx")))
  expect_equal(
    import_list("../testdata/example.xlsm", which = 1, format = "xlsx"),
    list(
      data.frame(A = 1),
      data.frame(B = 2)
    )
  )
})
