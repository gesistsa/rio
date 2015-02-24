context("Guess Correctness")

test_that("Guess correctness", {
    expect_that(.guess("hello.csv"), equals("csv"))
    expect_that(.guess("hello.CSV"), equals("csv"))
    expect_that(.guess("hello.sav.CSV"), equals("csv"))
})

test_that("Format Override Guessing", {
    expect_that(.guess("hello.csv", format="txt"), equals("txt"))
})
