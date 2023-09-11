test_that(".create_outfiles works", {
    x <- list(
        a = data.frame(),
        b = data.frame(),
        c = data.frame()
    )
    y <- list(
        data.frame(),
        data.frame(),
        data.frame()
    )
    expect_identical(.create_outfiles("d_%s.csv", x), c("d_a.csv", "d_b.csv", "d_c.csv"))
    expect_identical(.create_outfiles("d_%s.csv", y), c("d_1.csv", "d_2.csv", "d_3.csv"))
    expect_identical(.create_outfiles(c("a.csv", "b.csv", "c.csv"), x), c("a.csv", "b.csv", "c.csv"))
})

test_that(".create_outfiles errors", {
    x <- list(
        a = data.frame(),
        a = data.frame(),
        c = data.frame()
    )
    y <- list(
        a = data.frame(),
        b = data.frame(),
        data.frame()
    )
    expect_error(.create_outfiles("d_%s.csv", x))
    expect_error(.create_outfiles(c("a.csv", "a.csv", "c.csv"), x))
    expect_error(.create_outfiles(c("a.csv", "b.csv"), x))
    expect_error(.create_outfiles(c("a.csv"), x))
    expect_error(.create_outfiles(c("d_%s.csv"), y))
})
