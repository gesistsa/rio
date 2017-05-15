context("Fortran imports/exports")

test_that("Import from Fortran", {
    ff <- tempfile()
    cat(file = ff, "123456", "987654", sep = "\n")
    expect_true(inherits(import(ff, format = "fortran", style = c("F2.1","F2.0","I2")), "data.frame"))
    unlink(ff)
})
