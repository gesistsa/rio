context("Compressed files")

# tar export does not work due to: https://bugs.r-project.org/bugzilla3/show_bug.cgi?id=16716

e1 <- export(iris, "iris.csv.zip")
#e2 <- export(iris, "iris.csv.tar")
test_that("Export to compressed", {
    expect_true(e1 %in% dir())
    #expect_true(e2 %in% dir())
})

test_that("Import from compressed", {
    expect_true(is.data.frame(import(e1)))
    #expect_true(is.data.frame(import(e2)))
})

unlink(e1)
#unlink(e2)
