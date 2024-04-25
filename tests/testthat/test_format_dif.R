test_that("Import from DIF", {
    dd <- import(file.path(system.file("misc", package = "utils"), "exDIF.dif"), transpose = TRUE)
    expect_true(is.data.frame(dd))
})
