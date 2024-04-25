skip_if_not_installed("pzfx")

test_that("Export to and import from pzfx", {
    ## pzfx support only numeric data
    iris_numeric <- iris
    iris_numeric$Species <- as.numeric(iris_numeric$Species)
    withr::with_tempfile("iris_file", fileext = ".pzfx", code = {
        export(iris_numeric, iris_file)
        expect_true(file.exists(iris_file))
        expect_true(is.data.frame(import(iris_file)))
        ## Note that the dim test is only true as long as the data are exported with
        ## write_pzfx(..., row_names=FALSE) which is the default in the export
        ## method, but it is not default in pzfx::write_pzfx()
        expect_true(identical(dim(import(iris_file)), dim(iris_numeric)))
        expect_true(identical(dim(import(iris_file, which = "Data 1")), dim(iris_numeric)))
        expect_true(identical(dim(import(iris_file, table = "Data 1")), dim(iris_numeric)))
    })
})
