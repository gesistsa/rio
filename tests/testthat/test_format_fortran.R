test_that("Import from Fortran", {
    ## no fixed file extension
    withr::with_tempfile("fortran_file", code = {
        cat(file = fortran_file, "123456", "987654", sep = "\n")
        expect_true(is.data.frame(import(fortran_file, format = "fortran", style = c("F2.1","F2.0","I2"))))
    })
})
