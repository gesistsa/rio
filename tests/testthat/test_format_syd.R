skip_if_not_installed("foreign")

test_that("Import from Systat", {
    expect_true(is.data.frame(import(system.file("files/Iris.syd", package = "foreign")[1])))
})
