context("Compressed files")

test_that("Recognize compressed file types", {
    expect_true(rio:::find_compress("file.zip")$compress == "zip")
    expect_true(rio:::find_compress("file.tar")$compress == "tar")
    expect_true(rio:::find_compress("file.tar.gz")$compress == "tar")
    expect_true(is.na(rio:::find_compress("file.gz")$compress))
    expect_true(is.na(rio:::find_compress("file.notcompressed")$compress))
})

test_that("Export to compressed (zip) / import", {
    withr::with_tempfile("iris_path", fileext = ".csv.zip", code = {
        e1 <- export(iris, iris_path)
        expect_true(file.exists(iris_path))
        expect_true(is.data.frame(import(iris_path)))
        expect_true(is.data.frame(import(iris_path)))
        expect_true(is.data.frame(import(iris_path, which = 1)))
        base_file_name <- gsub("\\.zip", "", basename(iris_path))
        expect_true(is.data.frame(import(iris_path, which = base_file_name)))
    })
})

test_that("Export to compressed (tar)", {
    withr::with_tempfile("iris_path", fileext = ".csv.tar", code = {
        e2 <- export(iris, iris_path)
        expect_true(file.exists(iris_path))
        ## tar export does not work due to: https://bugs.r-project.org/bugzilla3/show_bug.cgi?id=16716
        ##expect_true(is.data.frame(import("iris.csv.tar")))
    })
})

## test_that("Import from compressed", {
##     expect_true(is.data.frame(import("iris.csv.zip")))
##     expect_true(is.data.frame(import("iris.csv.zip", which = 1)))
##     expect_true(is.data.frame(import("iris.csv.zip", which = "iris.csv")))
##     # tar export does not work due to: https://bugs.r-project.org/bugzilla3/show_bug.cgi?id=16716
##     #expect_true(is.data.frame(import("iris.csv.tar")))
## })

## unlink("iris.csv.tar")
