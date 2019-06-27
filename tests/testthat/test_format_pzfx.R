context("pzfx imports/exports")
require("datasets")

if (requireNamespace("pzfx")) {
  iris_numeric <- iris
  iris_numeric$Species <- as.numeric(iris_numeric$Species)
  test_that("Export to pzfx", {
    expect_true(export(iris_numeric, "iris.pzfx") %in% dir())
  })

  test_that("Import from pzfx", {
    expect_true(is.data.frame(import("iris.pzfx")))
    # Note that the dim test is only true as long as the data are exported with
    # write_pzfx(..., row_names=FALSE) which is the default in the export
    # method, but it is not default in pzfx::write_pzfx()
    expect_true(identical(dim(import("iris.pzfx")), dim(iris_numeric)))
  })

  unlink("iris.pzfx")
}
