
# rio: A Swiss-Army Knife for Data I/O <img src="man/figures/logo.png" align="right" height="139"/>

<!-- badges: start -->

[![CRAN
Version](https://www.r-pkg.org/badges/version/rio)](https://cran.r-project.org/package=rio)
![Downloads](https://cranlogs.r-pkg.org/badges/rio) <!-- badges: end -->

## Overview

The aim of **rio** is to make data file I/O in R as easy as possible by
implementing two main functions in Swiss-army knife style:

  - `import()` provides a painless data import experience by
    automatically choosing the appropriate import/read function based on
    file extension (or a specified `format` argument)
  - `export()` provides the same painless file recognition for data
    export/write functionality

## Installation

The package is available on
[CRAN](https://cran.r-project.org/package=rio) and can be installed
directly in R using `install.packages()`.

``` r
install.packages("rio")
```

The latest development version on GitHub can be installed using:

``` r
if (!require("remotes")){
    install.packages("remotes")
}
remotes::install_github("gesistsa/rio")
```

Optional: Installation of additional formats (see below: **Supported
file formats**)

``` r
library(rio)
install_formats()
```

## Usage

Because **rio** is meant to streamline data I/O, the package is
extremely easy to use. Here are some examples of reading, writing, and
converting data files.

### Import

Importing data is handled with one function, `import()`:

``` r
library("rio")
import("starwars.xlsx")
```

    ##                  Name homeworld species
    ## 1      Luke Skywalker  Tatooine   Human
    ## 2               C-3PO  Tatooine   Human
    ## 3               R2-D2  Alderaan   Human
    ## 4         Darth Vader  Tatooine   Human
    ## 5         Leia Organa  Tatooine   Human
    ## 6           Owen Lars  Tatooine   Human
    ## 7  Beru Whitesun lars   Stewjon   Human
    ## 8               R5-D4  Tatooine   Human
    ## 9   Biggs Darklighter  Kashyyyk Wookiee
    ## 10     Obi-Wan Kenobi  Corellia   Human

``` r
import("starwars.csv")
```

    ##                  Name homeworld species
    ## 1      Luke Skywalker  Tatooine   Human
    ## 2               C-3PO  Tatooine   Human
    ## 3               R2-D2  Alderaan   Human
    ## 4         Darth Vader  Tatooine   Human
    ## 5         Leia Organa  Tatooine   Human
    ## 6           Owen Lars  Tatooine   Human
    ## 7  Beru Whitesun lars   Stewjon   Human
    ## 8               R5-D4  Tatooine   Human
    ## 9   Biggs Darklighter  Kashyyyk Wookiee
    ## 10     Obi-Wan Kenobi  Corellia   Human

### Export

Exporting data is handled with one function, `export()`:

``` r
export(mtcars, "mtcars.csv") # comma-separated values
export(mtcars, "mtcars.rds") # R serialized
export(mtcars, "mtcars.sav") # SPSS
```

A particularly useful feature of rio is the ability to import from and
export to compressed archives (e.g., zip), saving users the extra step
of compressing a large exported file, e.g.:

``` r
export(mtcars, "mtcars.tsv.zip")
```

`export()` can also write multiple data frames to respective sheets of
an Excel workbook or an HTML file:

``` r
export(list(mtcars = mtcars, iris = iris), file = "mtcars.xlsx")
```

## Supported file formats

**rio** supports a wide range of file formats. To keep the package slim,
several formats are supported via “Suggests” packages, which are not
installed (or loaded) by default. You can check which formats are
**not** supported via:

``` r
show_unsupported_formats()
```

You can install the suggested packages individually, depending your own
needs. If you want to install all suggested packages:

``` r
install_formats()
```

The full list of supported formats is below:

| Name                                | Extensions / “format”               | Import Package | Export Package | Type    | Note                           |
| :---------------------------------- | :---------------------------------- | :------------- | :------------- | :------ | :----------------------------- |
| Archive files (handled by tar)      | tar / tar.gz / tgz / tar.bz2 / tbz2 | utils          | utils          | Default |                                |
| Bzip2                               | bz2 / bzip2                         | base           | base           | Default |                                |
| Gzip                                | gz / gzip                           | base           | base           | Default |                                |
| Zip files                           | zip                                 | utils          | utils          | Default |                                |
| Ambiguous file format               | dat                                 | data.table     |                | Default | Attempt as delimited text data |
| CSVY (CSV + YAML metadata header)   | csvy                                | data.table     | data.table     | Default |                                |
| Comma-separated data                | csv                                 | data.table     | data.table     | Default |                                |
| Comma-separated data (European)     | csv2                                | data.table     | data.table     | Default |                                |
| Data Interchange Format             | dif                                 | utils          |                | Default |                                |
| Epiinfo                             | epiinfo / rec                       | foreign        |                | Default |                                |
| Excel                               | excel / xlsx                        | readxl         | writexl        | Default |                                |
| Excel (Legacy)                      | xls                                 | readxl         |                | Default |                                |
| Fixed-width format data             | fwf                                 | readr          | utils          | Default |                                |
| Fortran data                        | fortran                             | utils          |                | Default | No recognized extension        |
| Google Sheets                       | googlesheets                        | data.table     |                | Default | As comma-separated data        |
| Minitab                             | minitab / mtp                       | foreign        |                | Default |                                |
| Pipe-separated data                 | psv                                 | data.table     | data.table     | Default |                                |
| R syntax                            | r                                   | base           | base           | Default |                                |
| SAS                                 | sas / sas7bdat                      | haven          | haven          | Default | Export is deprecated           |
| SAS XPORT                           | xport / xpt                         | haven          | haven          | Default |                                |
| SPSS                                | sav / spss                          | haven          | haven          | Default |                                |
| SPSS (compressed)                   | zsav                                | haven          | haven          | Default |                                |
| SPSS Portable                       | por                                 | haven          |                | Default |                                |
| Saved R objects                     | rda / rdata                         | base           | base           | Default |                                |
| Serialized R objects                | rds                                 | base           | base           | Default |                                |
| Stata                               | dta / stata                         | haven          | haven          | Default |                                |
| Systat                              | syd / systat                        | foreign        |                | Default |                                |
| Tab-separated data                  | / tsv / txt                         | data.table     | data.table     | Default |                                |
| Text Representations of R Objects   | dump                                | base           | base           | Default |                                |
| Weka Attribute-Relation File Format | arff / weka                         | foreign        | foreign        | Default |                                |
| XBASE database files                | dbf                                 | foreign        | foreign        | Default |                                |
| Apache Arrow (Parquet)              | parquet                             | nanoparquet    | nanoparquet    | Suggest |                                |
| Clipboard                           | clipboard                           | clipr          | clipr          | Suggest | default is tsv                 |
| EViews                              | eviews / wf1                        | hexView        |                | Suggest |                                |
| Fast Storage                        | fst                                 | fst            | fst            | Suggest |                                |
| Feather R/Python interchange format | feather                             | arrow          | arrow          | Suggest |                                |
| Graphpad Prism                      | pzfx                                | pzfx           | pzfx           | Suggest |                                |
| HTML Tables                         | htm / html                          | xml2           | xml2           | Suggest |                                |
| JSON                                | json                                | jsonlite       | jsonlite       | Suggest |                                |
| Matlab                              | mat / matlab                        | rmatio         | rmatio         | Suggest |                                |
| OpenDocument Spreadsheet            | ods                                 | readODS        | readODS        | Suggest |                                |
| OpenDocument Spreadsheet (Flat)     | fods                                | readODS        | readODS        | Suggest |                                |
| Serialized R objects (Quick)        | qs                                  | qs             | qs             | Suggest |                                |
| Shallow XML documents               | xml                                 | xml2           | xml2           | Suggest |                                |
| YAML                                | yaml / yml                          | yaml           | yaml           | Suggest |                                |

Additionally, any format that is not supported by **rio** but that has a
known R implementation will produce an informative error message
pointing to a package and import or export function. Unrecognized
formats will yield a simple “Unrecognized file format” error.

## Other functions

### Convert

The `convert()` function links `import()` and `export()` by constructing
a dataframe from the imported file and immediately writing it back to
disk. `convert()` invisibly returns the file name of the exported file,
so that it can be used to programmatically access the new file.

``` r
convert("mtcars.sav", "mtcars.dta")
```

It is also possible to use **rio** on the command-line by calling
`Rscript` with the `-e` (expression) argument. For example, to convert a
file from Stata (.dta) to comma-separated values (.csv), simply do the
following:

    Rscript -e "rio::convert('iris.dta', 'iris.csv')"

### \*\_list

`import_list()` allows users to import a list of data frames from a
multi-object file (such as an Excel workbook, .Rdata file, zip
directory, or HTML file):

``` r
str(m <- import_list("mtcars.xlsx"))
```

    ## List of 2
    ##  $ mtcars:'data.frame':  32 obs. of  11 variables:
    ##   ..$ mpg : num [1:32] 21 21 22.8 21.4 18.7 18.1 14.3 24.4 22.8 19.2 ...
    ##   ..$ cyl : num [1:32] 6 6 4 6 8 6 8 4 4 6 ...
    ##   ..$ disp: num [1:32] 160 160 108 258 360 ...
    ##   ..$ hp  : num [1:32] 110 110 93 110 175 105 245 62 95 123 ...
    ##   ..$ drat: num [1:32] 3.9 3.9 3.85 3.08 3.15 2.76 3.21 3.69 3.92 3.92 ...
    ##   ..$ wt  : num [1:32] 2.62 2.88 2.32 3.21 3.44 ...
    ##   ..$ qsec: num [1:32] 16.5 17 18.6 19.4 17 ...
    ##   ..$ vs  : num [1:32] 0 0 1 1 0 1 0 1 1 1 ...
    ##   ..$ am  : num [1:32] 1 1 1 0 0 0 0 0 0 0 ...
    ##   ..$ gear: num [1:32] 4 4 4 3 3 3 3 4 4 4 ...
    ##   ..$ carb: num [1:32] 4 4 1 1 2 1 4 2 2 4 ...
    ##  $ iris  :'data.frame':  150 obs. of  5 variables:
    ##   ..$ Sepal.Length: num [1:150] 5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...
    ##   ..$ Sepal.Width : num [1:150] 3.5 3 3.2 3.1 3.6 3.9 3.4 3.4 2.9 3.1 ...
    ##   ..$ Petal.Length: num [1:150] 1.4 1.4 1.3 1.5 1.4 1.7 1.4 1.5 1.4 1.5 ...
    ##   ..$ Petal.Width : num [1:150] 0.2 0.2 0.2 0.2 0.2 0.4 0.3 0.2 0.2 0.1 ...
    ##   ..$ Species     : chr [1:150] "setosa" "setosa" "setosa" "setosa" ...

`export_list()` makes it easy to export a list of (possibly named) data
frames to multiple files:

``` r
export_list(m, "%s.tsv")
c("mtcars.tsv", "iris.tsv") %in% dir()
```

    ## [1] TRUE TRUE

## Other projects

### GUIs

  - [**datamods**](https://cran.r-project.org/package=datamods) provides
    Shiny modules for importing data via `rio`.
  - [**rioweb**](https://github.com/lbraglia/rioweb) that provides
    access to the file conversion features of `rio`.
  - [**GREA**](https://github.com/Stan125/GREA/) is an RStudio add-in
    that provides an interactive interface for reading in data using
    `rio`.

### Similar packages

  - [**reader**](https://cran.r-project.org/package=reader) handles
    certain text formats and R binary files
  - [**io**](https://cran.r-project.org/package=io) offers a set of
    custom formats
  - [**ImportExport**](https://cran.r-project.org/package=ImportExport)
    focuses on select binary formats (Excel, SPSS, and Access files) and
    provides a Shiny interface.
  - [**SchemaOnRead**](https://cran.r-project.org/package=SchemaOnRead)
    iterates through a large number of possible import methods until one
    works successfully
