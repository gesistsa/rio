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

test_that("install_formats()", {
  suggestions <- read.dcf(system.file("examples/example-DESCRIPTION",
                                      package = "rio", mustWork = TRUE),
                          fields = "Suggests")
  suggestions <- parse_suggestions(suggestions)
  expect_true("NANTUCKET" %in% suggestions)
  expect_true("readODS" %in% suggestions)
  expect_false("devtools" %in% suggestions)
})
