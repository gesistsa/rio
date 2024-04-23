test_that("export to nonexisting directory #347", {
    withr::with_tempdir({
        output_dir <- file.path(".", "this_doesnt_exist")
        expect_false(dir.exists(output_dir))
        expect_error(export(iris, file.path(output_dir, "iris.csv")), NA)
        expect_true(file.exists(file.path(output_dir, "iris.csv")))
    })
})

test_that("export to existing directory (contra previous one) #347", {
    withr::with_tempdir({
        output_dir <- file.path(".", "this_surely_exist1")
        dir.create(output_dir, recursive = TRUE) ## right?
        expect_true(dir.exists(output_dir))
        expect_error(export(iris, file.path(output_dir, "iris.csv")), NA)
        expect_true(file.exists(file.path(output_dir, "iris.csv")))
    })
})

test_that("export to nonexisting directory also for compressed file  #347", {
    withr::with_tempdir({
        output_dir <- file.path(".", "this_doesnt_exist")
        expect_false(dir.exists(output_dir))
        expect_error(export(iris, file.path(output_dir, "iris.csv.gz")), NA)
        expect_true(file.exists(file.path(output_dir, "iris.csv.gz")))
    })
})
