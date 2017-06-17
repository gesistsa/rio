context("characterize()/factorize()")
x <- structure(1:4, labels = c("A" = 1, "B" = 2, "C" = 3))
xdf <- data.frame(v1 = structure(1:4, labels = c("A" = 1, "B" = 2, "C" = 3)),
                  v2 = structure(c(1,0,0,1), labels = c("foo" = 0, "bar" = 1)))


test_that("test characterize.default()", {
    expect_true(identical(characterize(x), c(LETTERS[1:3], NA)))
})

test_that("test characterize.default()", {
    expect_true(identical(characterize(xdf), {xdf[] <- lapply(xdf, characterize); xdf}))
})

test_that("test factorize.data.frame()", {
    expect_true(identical(factorize(x), factor(x, attributes(x)$labels, names(attributes(x)$labels))))
})

test_that("test factorize.data.frame()", {
    expect_true(identical(factorize(xdf), {xdf[] <- lapply(xdf, factorize); xdf}))
})
