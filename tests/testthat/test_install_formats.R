context("Install uninstalled formats")

test_that("uninstalled_formats()", {
    skip_on_cran()
    formats <- uninstalled_formats()
    if (is.null(formats)) {
        expect_true(install_formats())
    } else {
        expect_type(formats, "character")
    }
})
