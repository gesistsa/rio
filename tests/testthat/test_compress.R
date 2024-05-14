context("Compressed files")

test_that("Recognize compressed file types", {
    expect_true(rio:::find_compress("file.zip")$compress == "zip")
    expect_true(rio:::find_compress("file.tar")$compress == "tar")
    expect_true(rio:::find_compress("file.tar.gz")$compress == "tar.gz")
    expect_true(rio:::find_compress("file.gzip")$compress == "gzip")
    expect_true(rio:::find_compress("file.gz")$compress == "gzip")
    expect_true(is.na(rio:::find_compress("file.notcompressed")$compress))
})

test_that("Export to compressed (zip, tar) / import", {
    skip_if(getRversion() <= "4.0")
    formats <- c("zip", "tar", "tar.gz")
    for (format in formats) {
        withr::with_tempfile("iris_path", fileext = paste0(".csv.", format), code = {
            e1 <- export(iris, iris_path)
            expect_true(file.exists(iris_path))
            expect_true(is.data.frame(import(iris_path)))
            expect_true(is.data.frame(import(iris_path, which = 1)))
            base_file_name <- gsub(paste0("\\.", format), "", basename(iris_path))
            expect_true(is.data.frame(import(iris_path, which = base_file_name)))
            if (format == "tar.gz") {
                expect_true(R.utils::isGzipped(iris_path, method = "content"))
            }
        })
    }
})

test_that("Multi-item zip", {
    formats <- c("zip")
    for (format in formats) {
        withr::with_tempfile("iris_path", fileext = paste0(".csv.", format), code = {
            list_of_df <- list(mtcars1 = mtcars[1:10, ], mtcars2 = mtcars[11:20, ], mtcars3 = mtcars[21:32, ])
            export_list(list_of_df, file = "%s.csv", archive = iris_path)
            y <- import(iris_path)
            expect_true(is.data.frame(y))
            expect_silent(z1 <- import(iris_path, which = 1))
            expect_silent(z2 <- import(iris_path, which = 2))
            expect_true(identical(y, z1))
            expect_false(identical(y, z2))
        })
    }
})

test_that("Export to compressed (gz, bz2) / import", {
    formats <- c("gz", "gzip", "bz2", "bzip2")
    for (format in formats) {
        withr::with_tempfile("iris_path", fileext = paste0(".csv.", format), code = {
            e1 <- export(iris, iris_path)
            expect_true(file.exists(iris_path))
            expect_true(is.data.frame(import(iris_path)))
            if (format %in% c("gzip", "gz")) {
                expect_true(R.utils::isGzipped(iris_path, method = "content"))
            }
            if (format %in% c("bzip2", "bz2")) {
                expect_true(R.utils::isBzipped(iris_path, method = "content"))
            }
        })
    }
})
