context("EViews import")

if (requireNamespace("hexView")) {
    test_that("Import from EViews", {
        expect_true(is.data.frame(suppressWarnings(import(hexView::hexViewFile("data4-1.wf1")))))
    })
}
