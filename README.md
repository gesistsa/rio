# rio

The aim of `rio` is to make data file I/O in R as easy as possible. The swiss-army knife-sytle functions `export` and `import` provide painless data file I/O experience.

## example

```R
require(rio)
export(iris, "iris.csv")
export(iris, "iris.rds")
export(iris, "iris.dta")

x <- import("iris.csv")
y <- import("iris.rds")
z <- import("iris.dta")
```

## Installation

```R
require(devtools)
install_github("rio", "chainsawriot")
```
