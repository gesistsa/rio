# Working with labelled data

``` r
library(rio)
library(haven)
```

Formats SAS, SPSS, and Stata use `haven` as import and export functions.
And these formats can have the so-called labelled data. For more
information, please read
[`vignette("semantics", "haven")`](https://haven.tidyverse.org/articles/semantics.html).
Here, we provide a quick guide on how to work with labelled data using
`rio`.

You can use
[`haven::labelled()`](https://haven.tidyverse.org/reference/labelled.html)
to create labelled data.

``` r
gender <- haven::labelled(
                     c("M", "F", "F", "F", "M"),
                     c(Male = "M", Female = "F"))
```

Or directly using `attrs`

``` r
rating <- sample(1:5)
attr(rating, "labels") <-  c(c(Good = 1, Bad = 5))
```

``` r
mydata <- data.frame(gender, rating)
```

Round trip: The data labels are retained. But they are at the variable
level.

``` r
export(mydata, "mydata.sav")
restored_data <- rio::import("mydata.sav")
str(restored_data)
#> 'data.frame':    5 obs. of  2 variables:
#>  $ gender: chr  "M" "F" "F" "F" ...
#>   ..- attr(*, "format.spss")= chr "A1"
#>   ..- attr(*, "labels")= Named chr [1:2] "M" "F"
#>   .. ..- attr(*, "names")= chr [1:2] "Male" "Female"
#>  $ rating: num  5 3 4 1 2
#>   ..- attr(*, "format.spss")= chr "F8.0"
#>   ..- attr(*, "labels")= Named num [1:2] 1 5
#>   .. ..- attr(*, "names")= chr [1:2] "Good" "Bad"
```

[`rio::gather_attrs()`](http://gesistsa.github.io/rio/reference/gather_attrs.md)
converts attributes to the data.frame level

``` r
g <- rio::gather_attrs(restored_data)
str(g)
#> 'data.frame':    5 obs. of  2 variables:
#>  $ gender: chr  "M" "F" "F" "F" ...
#>   ..- attr(*, "labels")= Named chr [1:2] "M" "F"
#>   .. ..- attr(*, "names")= chr [1:2] "Male" "Female"
#>  $ rating: num  5 3 4 1 2
#>   ..- attr(*, "labels")= Named num [1:2] 1 5
#>   .. ..- attr(*, "names")= chr [1:2] "Good" "Bad"
#>  - attr(*, "format.spss")=List of 2
#>   ..$ gender: chr "A1"
#>   ..$ rating: chr "F8.0"
#>  - attr(*, "labels")=List of 2
#>   ..$ gender: Named chr [1:2] "M" "F"
#>   .. ..- attr(*, "names")= chr [1:2] "Male" "Female"
#>   ..$ rating: Named num [1:2] 1 5
#>   .. ..- attr(*, "names")= chr [1:2] "Good" "Bad"
attr(g, "labels")
#> $gender
#>   Male Female 
#>    "M"    "F" 
#> 
#> $rating
#> Good  Bad 
#>    1    5
```
