# Export list of data frames to files

Use [`export()`](http://gesistsa.github.io/rio/reference/export.md) to
export a list of data frames to a vector of file names or a filename
pattern.

## Usage

``` r
export_list(x, file, archive = "", ...)
```

## Arguments

- x:

  A list of data frames to be written to files.

- file:

  A character vector string containing a single file name with a `\%s`
  wildcard placeholder, or a vector of file paths for multiple files to
  be imported. If `x` elements are named, these will be used in place of
  `\%s`, otherwise numbers will be used; all elements must be named for
  names to be used.

- archive:

  character. Either empty string (default) to save files in current
  directory, a path to a (new) directory, or a .zip/.tar file to
  compress all files into an archive.

- ...:

  Additional arguments passed to
  [`export()`](http://gesistsa.github.io/rio/reference/export.md).

## Value

The name(s) of the output file(s) as a character vector (invisibly).

## Details

[`export()`](http://gesistsa.github.io/rio/reference/export.md) can
export a list of data frames to a single multi-dataset file (e.g., an
Rdata or Excel .xlsx file). Use `export_list` to export such a list to
*multiple* files.

## See also

[`import()`](http://gesistsa.github.io/rio/reference/import.md),
[`import_list()`](http://gesistsa.github.io/rio/reference/import_list.md),
[`export()`](http://gesistsa.github.io/rio/reference/export.md)

## Examples

``` r
## For demo, a temp. file path is created with the file extension .xlsx
xlsx_file <- tempfile(fileext = ".xlsx")
export(
    list(
        mtcars1 = mtcars[1:10, ],
        mtcars2 = mtcars[11:20, ],
        mtcars3 = mtcars[21:32, ]
    ),
    xlsx_file
)

# import a single file from multi-object workbook
import(xlsx_file, sheet = "mtcars1")
#>     mpg cyl  disp  hp drat    wt  qsec vs am gear carb
#> 1  21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
#> 2  21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
#> 3  22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
#> 4  21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1
#> 5  18.7   8 360.0 175 3.15 3.440 17.02  0  0    3    2
#> 6  18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1
#> 7  14.3   8 360.0 245 3.21 3.570 15.84  0  0    3    4
#> 8  24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2
#> 9  22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2
#> 10 19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
# import all worksheets, the return value is a list
import_list(xlsx_file)
#> $mtcars1
#>     mpg cyl  disp  hp drat    wt  qsec vs am gear carb
#> 1  21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
#> 2  21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
#> 3  22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
#> 4  21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1
#> 5  18.7   8 360.0 175 3.15 3.440 17.02  0  0    3    2
#> 6  18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1
#> 7  14.3   8 360.0 245 3.21 3.570 15.84  0  0    3    4
#> 8  24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2
#> 9  22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2
#> 10 19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
#> 
#> $mtcars2
#>     mpg cyl  disp  hp drat    wt  qsec vs am gear carb
#> 1  17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4
#> 2  16.4   8 275.8 180 3.07 4.070 17.40  0  0    3    3
#> 3  17.3   8 275.8 180 3.07 3.730 17.60  0  0    3    3
#> 4  15.2   8 275.8 180 3.07 3.780 18.00  0  0    3    3
#> 5  10.4   8 472.0 205 2.93 5.250 17.98  0  0    3    4
#> 6  10.4   8 460.0 215 3.00 5.424 17.82  0  0    3    4
#> 7  14.7   8 440.0 230 3.23 5.345 17.42  0  0    3    4
#> 8  32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1
#> 9  30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2
#> 10 33.9   4  71.1  65 4.22 1.835 19.90  1  1    4    1
#> 
#> $mtcars3
#>     mpg cyl  disp  hp drat    wt  qsec vs am gear carb
#> 1  21.5   4 120.1  97 3.70 2.465 20.01  1  0    3    1
#> 2  15.5   8 318.0 150 2.76 3.520 16.87  0  0    3    2
#> 3  15.2   8 304.0 150 3.15 3.435 17.30  0  0    3    2
#> 4  13.3   8 350.0 245 3.73 3.840 15.41  0  0    3    4
#> 5  19.2   8 400.0 175 3.08 3.845 17.05  0  0    3    2
#> 6  27.3   4  79.0  66 4.08 1.935 18.90  1  1    4    1
#> 7  26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2
#> 8  30.4   4  95.1 113 3.77 1.513 16.90  1  1    5    2
#> 9  15.8   8 351.0 264 4.22 3.170 14.50  0  1    5    4
#> 10 19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6
#> 11 15.0   8 301.0 335 3.54 3.570 14.60  0  1    5    8
#> 12 21.4   4 121.0 109 4.11 2.780 18.60  1  1    4    2
#> 
library('datasets')
export(list(mtcars1 = mtcars[1:10,],
            mtcars2 = mtcars[11:20,],
            mtcars3 = mtcars[21:32,]),
    xlsx_file <- tempfile(fileext = ".xlsx")
)

# import all worksheets
list_of_dfs <- import_list(xlsx_file)

# re-export as separate named files

## export_list(list_of_dfs, file = c("file1.csv", "file2.csv", "file3.csv"))

# re-export as separate files using a name pattern; using the names in the list
## This will be written as "mtcars1.csv", "mtcars2.csv", "mtcars3.csv"

## export_list(list_of_dfs, file = "%s.csv")
```
