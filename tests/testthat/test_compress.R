context("Compressed files")

test_that("Recognize compressed file types", {
    expect_true(rio:::find_compress("file.zip")$compress == "zip")
    expect_true(rio:::find_compress("file.tar")$compress == "tar")
    expect_true(rio:::find_compress("file.tar.gz")$compress == "tar")
    expect_true(is.na(rio:::find_compress("file.gz")$compress))
    expect_true(is.na(rio:::find_compress("file.notcompressed")$compress))
})

test_that("Export to compressed", {
    e1 <- export(iris, "iris.csv.zip")
    #e2 <- export(iris, "iris.csv.tar")
    expect_true(e1 %in% dir())
    #expect_true(e2 %in% dir())
})

test_that("Import from compressed", {
    expect_true(is.data.frame(import("iris.csv.zip")))
    expect_true(is.data.frame(import("iris.csv.zip", which = 1)))
    expect_true(is.data.frame(import("iris.csv.zip", which = "iris.csv")))
    # tar export does not work due to: https://bugs.r-project.org/bugzilla3/show_bug.cgi?id=16716
    #expect_true(is.data.frame(import("iris.csv.tar")))
})

unlink("iris.csv.zip")
#unlink("iris.csv.tar")
