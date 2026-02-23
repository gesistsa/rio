# Import list of data frames

Use [`import()`](http://gesistsa.github.io/rio/reference/import.md) to
import a list of data frames from a vector of file names or from a
multi-object file (Excel workbook, .Rdata file, compressed directory in
a zip file or tar archive, or HTML file)

## Usage

``` r
import_list(
  file,
  setclass = getOption("rio.import.class", "data.frame"),
  which,
  rbind = FALSE,
  rbind_label = "_file",
  rbind_fill = TRUE,
  ...
)
```

## Arguments

- file:

  A character string containing a single file name for a multi-object
  file (e.g., Excel workbook, zip file, tar archive, or HTML file), or a
  vector of file paths for multiple files to be imported.

- setclass:

  An optional character vector specifying one or more classes to set on
  the import. By default, the return object is always a “data.frame”.
  Allowed values include “tbl_df”, “tbl”, or “tibble” (if using tibble),
  “arrow”, “arrow_table” (if using arrow table; the suggested package
  `arrow` must be installed) or “data.table” (if using data.table).
  Other values are ignored, such that a data.frame is returned. The
  parameter takes precedents over parameters in ... which set a
  different class.

- which:

  If `file` is a single file path, this specifies which objects should
  be extracted (passed to
  [`import()`](http://gesistsa.github.io/rio/reference/import.md)'s
  `which` argument). Ignored otherwise.

- rbind:

  A logical indicating whether to pass the import list of data frames
  through
  [`data.table::rbindlist()`](https://rdrr.io/pkg/data.table/man/rbindlist.html).

- rbind_label:

  If `rbind = TRUE`, a character string specifying the name of a column
  to add to the data frame indicating its source file.

- rbind_fill:

  If `rbind = TRUE`, a logical indicating whether to set the
  `fill = TRUE` (and fill missing columns with `NA`).

- ...:

  Additional arguments passed to
  [`import()`](http://gesistsa.github.io/rio/reference/import.md).
  Behavior may be unexpected if files are of different formats.

## Value

If `rbind=FALSE` (the default), a list of a data frames. Otherwise, that
list is passed to
[`data.table::rbindlist()`](https://rdrr.io/pkg/data.table/man/rbindlist.html)
with `fill = TRUE` and returns a data frame object of class set by the
`setclass` argument; if this operation fails, the list is returned.

## Details

When file is a vector of file paths and any files are missing, those
files are ignored (with warnings) and this function will not raise any
error. For compressed files, the file name must also contain information
about the file format of all compressed files, e.g. `files.csv.zip` for
this function to work.

## Trust

For serialization formats (.R, .RDS, and .RData), please note that you
should only load these files from trusted sources. It is because these
formats are not necessarily for storing rectangular data and can also be
used to store many things, e.g. code. Importing these files could lead
to arbitary code execution. Please read the security principles by the R
Project (Plummer, 2024). When importing these files via `rio`, you
should affirm that you trust these files, i.e. `trust = TRUE`. See
example below. If this affirmation is missing, the current version
assumes `trust` to be true for backward compatibility and a deprecation
notice will be printed. In the next major release (2.0.0), you must
explicitly affirm your trust when importing these files.

## Which

For compressed archives (zip and tar, where a compressed file can
contain multiple files), it is possible to come to a situation where the
parameter `which` is used twice to indicate two different concepts. For
example, it is unclear for `.xlsx.zip`whether `which` refers to the
selection of an exact file in the archive or the selection of an exact
sheet in the decompressed Excel file. In these cases, `rio` assumes that
`which` is only used for the selection of file. After the selection of
file with `which`, `rio` will return the first item, e.g. the first
sheet.

Please note, however, `.gz` and `.bz2` (e.g. `.xlsx.gz`) are compressed,
but not archive format. In those cases, `which` is used the same way as
the non-compressed format, e.g. selection of sheet for Excel.

## References

Plummer, M (2024). Statement on CVE-2024-27322.
<https://blog.r-project.org/2024/05/10/statement-on-cve-2024-27322/>

## See also

[`import()`](http://gesistsa.github.io/rio/reference/import.md),
[`export_list()`](http://gesistsa.github.io/rio/reference/export_list.md),
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

# import and rbind all worksheets, the return value is a data frame
import_list(xlsx_file, rbind = TRUE)
#>     mpg cyl  disp  hp drat    wt  qsec vs am gear carb _file
#> 1  21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4     1
#> 2  21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4     1
#> 3  22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1     1
#> 4  21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1     1
#> 5  18.7   8 360.0 175 3.15 3.440 17.02  0  0    3    2     1
#> 6  18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1     1
#> 7  14.3   8 360.0 245 3.21 3.570 15.84  0  0    3    4     1
#> 8  24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2     1
#> 9  22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2     1
#> 10 19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4     1
#> 11 17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4     2
#> 12 16.4   8 275.8 180 3.07 4.070 17.40  0  0    3    3     2
#> 13 17.3   8 275.8 180 3.07 3.730 17.60  0  0    3    3     2
#> 14 15.2   8 275.8 180 3.07 3.780 18.00  0  0    3    3     2
#> 15 10.4   8 472.0 205 2.93 5.250 17.98  0  0    3    4     2
#> 16 10.4   8 460.0 215 3.00 5.424 17.82  0  0    3    4     2
#> 17 14.7   8 440.0 230 3.23 5.345 17.42  0  0    3    4     2
#> 18 32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1     2
#> 19 30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2     2
#> 20 33.9   4  71.1  65 4.22 1.835 19.90  1  1    4    1     2
#> 21 21.5   4 120.1  97 3.70 2.465 20.01  1  0    3    1     3
#> 22 15.5   8 318.0 150 2.76 3.520 16.87  0  0    3    2     3
#> 23 15.2   8 304.0 150 3.15 3.435 17.30  0  0    3    2     3
#> 24 13.3   8 350.0 245 3.73 3.840 15.41  0  0    3    4     3
#> 25 19.2   8 400.0 175 3.08 3.845 17.05  0  0    3    2     3
#> 26 27.3   4  79.0  66 4.08 1.935 18.90  1  1    4    1     3
#> 27 26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2     3
#> 28 30.4   4  95.1 113 3.77 1.513 16.90  1  1    5    2     3
#> 29 15.8   8 351.0 264 4.22 3.170 14.50  0  1    5    4     3
#> 30 19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6     3
#> 31 15.0   8 301.0 335 3.54 3.570 14.60  0  1    5    8     3
#> 32 21.4   4 121.0 109 4.11 2.780 18.60  1  1    4    2     3
```
