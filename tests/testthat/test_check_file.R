test_that(".check_file", {
    data <- data.frame(
        x = sample(1:10, 10000, replace = TRUE),
        y = sample(1:10, 10000, replace = TRUE)
    )
    expect_error(.check_file(1))
    expect_error(.check_file(TRUE))
    expect_error(.check_file(data))
    expect_error(.check_file(iris))
    expect_error(.check_file(c("a.csv", "b.csv")))
    expect_error(.check_file(NA))
    expect_error(.check_file(NA_character_))
    expect_error(.check_file(c(NA, "a.csv")))
    expect_error(.check_file(c(NA_character_, "a.csv")))
    expect_error(.check_file("a.csv"), NA)
    expect_error(.check_file(), NA)
    ## single_only FALSE
    expect_error(.check_file(1, single_only = FALSE))
    expect_error(.check_file(TRUE, single_only = FALSE))
    expect_error(.check_file(data, single_only = FALSE))
    expect_error(.check_file(iris, single_only = FALSE))
    expect_error(.check_file(c("a.csv", "b.csv"), single_only = FALSE), NA)
    expect_error(.check_file("a.csv"), NA)
    expect_error(.check_file(single_only = FALSE), NA)
})

test_that("Invalid file argument - import(), #301", {
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

test_that("Invalid file argument - import_list(), #301", {
    data <- data.frame(
        x = sample(1:10, 10000, replace = TRUE),
        y = sample(1:10, 10000, replace = TRUE)
    )
    expect_error(import_list(data), "Invalid")
    expect_error(import_list(iris), "Invalid")
    expect_error(import_list(1), "Invalid")
    expect_error(import_list(TRUE), "Invalid")
})

test_that("Invalid file argument - export(), #301", {
    data <- data.frame(
        x = sample(1:10, 10000, replace = TRUE),
        y = sample(1:10, 10000, replace = TRUE)
    )
    expect_error(export(iris, data), "Invalid")
    expect_error(export(iris, iris), "Invalid")
    expect_error(export(iris, 1), "Invalid")
    expect_error(export(iris, TRUE), "Invalid")
    expect_error(export(iris, c("abc.csv", "123.csv")), "Invalid")
})

test_that("Invalid file argument - export_list(), #301", {
    data <- data.frame(
        x = sample(1:10, 10000, replace = TRUE),
        y = sample(1:10, 10000, replace = TRUE)
    )
    expect_error(export_list(iris, data), "Invalid")
    expect_error(export_list(iris, iris), "Invalid")
    expect_error(export_list(iris, 1), "Invalid")
    expect_error(export_list(iris, TRUE), "Invalid")
})
