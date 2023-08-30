
test_that("Invalid file argument, #301", {
    data <- data.frame(
        x = sample(1:10, 10000, replace = TRUE),
        y = sample(1:10, 10000, replace = TRUE)
    )
    expect_error(import(data), "Invalid")
    expect_error(import(iris), "Invalid")
    expect_error(import(1), "Invalid")
    expect_error(import(TRUE), "Invalid")
    expect_error(import(c("a.csv", "b.csv")), "Invalid")
})
