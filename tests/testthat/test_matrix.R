test_that("Export matrix to and import from CSV", {
    withr::with_tempfile("temp_files", fileext = c(".csv", ".csv"), code = {
        export(warpbreaks, temp_files[1])
        export(as.matrix(warpbreaks), temp_files[2])
        expect_true(file.exists(temp_files[1]))
        expect_true(file.exists(temp_files[2]))
        expect_true(identical(import(temp_files[1], colClasses = rep("character", 3)),
                              import(temp_files[2], colClasses = rep("character", 3))))
    })
})
