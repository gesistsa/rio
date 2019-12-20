context("Systat (.syd) imports/exports")

test_that("Import from Systat", {
    skip_if_not_installed("foreign")
    expect_true(inherits(import(system.file("files/Iris.syd", package="foreign")[1]), "data.frame"))
})
