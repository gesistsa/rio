test_that("uninstalled_formats()", {
    skip_on_cran()
    formats <- uninstalled_formats()
    if (is.null(formats)) {
        expect_true(install_formats())
    } else {
        expect_type(formats, "character")
    }
})


test_that("show_unsupported_formats (in the fully supported environment) on CI", {
    skip_on_cran()
    expect_false(show_unsupported_formats())
})

test_that("show_unsupported_formats (in the partial supported environment) on CI", {
    skip_on_cran()
    fake_uninstalled_formats <- function() {
        return(c("readODS"))
    }
    with_mocked_bindings(code = {
        expect_true(show_unsupported_formats())
    }, `uninstalled_formats` = fake_uninstalled_formats)
})
