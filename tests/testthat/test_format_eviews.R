test_that("Import from EViews", {
    skip_if_not_installed(pkg = "hexView")
    expect_true(is.data.frame(suppressWarnings(import(hexView::hexViewFile("data4-1.wf1")))))
})
