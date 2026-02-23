# Gather attributes from data frame variables

`gather_attrs` moves variable-level attributes to the data frame level
and `spread_attrs` reverses that operation.

## Usage

``` r
gather_attrs(x)

spread_attrs(x)
```

## Arguments

- x:

  A data frame.

## Value

`x`, with variable-level attributes stored at the data frame level.

## Details

[`import()`](http://gesistsa.github.io/rio/reference/import.md) attempts
to standardize the return value from the various import functions to the
extent possible, thus providing a uniform data structure regardless of
what import package or function is used. It achieves this by storing any
optional variable-related attributes at the variable level (i.e., an
attribute for `mtcars$mpg` is stored in `attributes(mtcars$mpg)` rather
than `attributes(mtcars)`). `gather_attrs` moves these to the data frame
level (i.e., in `attributes(mtcars)`). `spread_attrs` moves attributes
back to the variable level.

## See also

[`import()`](http://gesistsa.github.io/rio/reference/import.md),
[`characterize()`](http://gesistsa.github.io/rio/reference/characterize.md)
