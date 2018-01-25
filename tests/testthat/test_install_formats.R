context("Install uninstalled formats")

test_that("install_formats()", {
    skip_on_cran()
    expect_true(install_formats())
})
