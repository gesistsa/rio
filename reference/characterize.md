# Character conversion of labelled data

Convert labelled variables to character or factor

## Usage

``` r
characterize(x, ...)

factorize(x, ...)

# Default S3 method
characterize(x, ...)

# S3 method for class 'data.frame'
characterize(x, ...)

# Default S3 method
factorize(x, coerce_character = FALSE, ...)

# S3 method for class 'data.frame'
factorize(x, ...)
```

## Arguments

- x:

  A vector or data frame.

- ...:

  additional arguments passed to methods

- coerce_character:

  A logical indicating whether to additionally coerce character columns
  to factor (in `factorize`). Default `FALSE`.

## Value

a character vector (for `characterize`) or factor vector (for
`factorize`)

## Details

`characterize` converts a vector with a `labels` attribute of named
levels into a character vector. `factorize` does the same but to
factors. This can be useful at two stages of a data workflow: (1)
importing labelled data from metadata-rich file formats (e.g., Stata or
SPSS), and (2) exporting such data to plain text files (e.g., CSV) in a
way that preserves information.

## See also

[`gather_attrs()`](http://gesistsa.github.io/rio/reference/gather_attrs.md)

## Examples

``` r
## vector method
x <- structure(1:4, labels = c("A" = 1, "B" = 2, "C" = 3))
characterize(x)
#> [1] "A" "B" "C" NA 
factorize(x)
#> [1] A    B    C    <NA>
#> Levels: A B C

## data frame method
x <- data.frame(v1 = structure(1:4, labels = c("A" = 1, "B" = 2, "C" = 3)),
                v2 = structure(c(1,0,0,1), labels = c("foo" = 0, "bar" = 1)))
str(factorize(x))
#> 'data.frame':    4 obs. of  2 variables:
#>  $ v1: Factor w/ 3 levels "A","B","C": 1 2 3 NA
#>  $ v2: Factor w/ 2 levels "foo","bar": 2 1 1 2
str(characterize(x))
#> 'data.frame':    4 obs. of  2 variables:
#>  $ v1: chr  "A" "B" "C" NA
#>  $ v2: chr  "bar" "foo" "foo" "bar"

## Application
csv_file <- tempfile(fileext = ".csv")
## comparison of exported file contents
import(export(x, csv_file))
#>   v1 v2
#> 1  1  1
#> 2  2  0
#> 3  3  0
#> 4  4  1
import(export(factorize(x), csv_file))
#>   v1  v2
#> 1  A bar
#> 2  B foo
#> 3  C foo
#> 4    bar
```
