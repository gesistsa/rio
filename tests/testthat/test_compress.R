context("Compressed files")

test_that("Recognize compressed file types", {
    expect_true(rio:::find_compress("file.zip")$compress == "zip")
    expect_true(rio:::find_compress("file.tar")$compress == "tar")
    expect_true(rio:::find_compress("file.gzip")$compress == "gzip")
    ## expect_true(rio:::find_compress("file.tar.gz")$compress == "tar")
    expect_true(is.na(rio:::find_compress("file.gz")$compress))
    expect_true(is.na(rio:::find_compress("file.notcompressed")$compress))
})

test_that("Export to compressed (zip) / import", {
    skip_if(getRversion() <= "4.0")
    ##formats <- c("zip", "tar", "gzip", "bzip2", "xz")
    formats <- c("zip", "tar") ## 395 #396
    for (format in formats) {
        withr::with_tempfile("iris_path", fileext = paste0(".csv.", format), code = {
            e1 <- export(iris, iris_path)
            expect_true(file.exists(iris_path))
            expect_true(is.data.frame(import(iris_path)))
            expect_true(is.data.frame(import(iris_path)))
            expect_true(is.data.frame(import(iris_path, which = 1)))
            base_file_name <- gsub(paste0("\\.", format), "", basename(iris_path))
            expect_true(is.data.frame(import(iris_path, which = base_file_name)))
        })
    }
})
