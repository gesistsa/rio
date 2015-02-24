# rio: A Swiss-army knife for data I/O #

The aim of **rio** is to make data file I/O in R as easy as possible by implementing three simple functions in Swiss-army knife style:

 - `export` and `import` provide a painless data I/O experience by automatically choosing the appropriate data read or write function based on file extension
 - `convert` wraps `import` and `export` to allow the user to easily convert between file formats (thus providing a FOSS replacement for programs like [Stat/Transfer](https://www.stattransfer.com/) or [Sledgehammer](http://www.openmetadata.org/site/?page_id=1089))

The core advantage of **rio** is that it makes assumptions that the user is probably willing to make. Two of these are important. First, **rio** uses the file extension of a file name to determine what kind of file it is. This is the same logic used by Windows OS, for example, in determining what application is associated with a given file type. By taking away the need to manually match a file type (which a beginner may not recognize) to a particular import or export function, **rio** allows almost all common data formats to be read with the same function. Second, when importing tabular data (CSV, TSV, etc.), **rio** does not convert strings to factors.
 
Another weakness of the base R data I/O functions is that they only support import of web-based data from websites serving HTTP, not HTTPS. For example, data stored on GitHub as publicly visible files cannot be read directly into R without either manually downloading them or reading them in via **RCurl** or **httr**. **rio** removes those steps by supporting HTTPS imports automatically.
 
The package also wraps a variety of faster, more stream-lined I/O packages than those provided by base R or the **foreign** package. Namely, the package uses [**haven**](https://github.com/hadley/haven) for reading and writing SAS, Stata, and SPSS files and [**fastread**](https://github.com/hadley/fastread) for reading simple text-delimited and fixed-width file formats.

## Supported file formats ##

**rio** supports a variety of different file formats for import and export.

*Import*

* txt (tab-seperated)
* tsv
* csv
* rds
* Rdata
* json
* dta (Stata)
* sav (SPSS)
* por (SPSS portable)
* sas7bdat (SAS)
* xpt (SAS XPORT)
* mtp (Minitab)
* rec (Epiinfo)
* syd (Systat)
* dif (Data Interchange Format)
* dbf ("XBASE" database files)
* xlsx (Excel)
* arff (Weka Attribute-Relation File Format)

**Export**

* txt (tab-seperated)
* tsv
* csv
* rds
* Rdata
* json
* dbf ("XBASE" database files)
* dta (Stata)
* sav (SPSS)
* xlsx (Excel)
* arff (Weka Attribute-Relation File Format)
* clipboard (on Mac and Windows only; as tab-separated data)


## Package Installation ##

The package is available on [CRAN](http://cran.r-project.org/web/packages/rio/) and can be installed directly in R using:

```R
install.packages("rio")
```

The latest development version on GitHub can be installed using **devtools**:

```R
if(!require("devtools")){
    install.packages("devtools")
    library("devtools")
}
install_github("leeper/rio")
```

[![Build Status](https://travis-ci.org/leeper/rio.png?branch=master)](https://travis-ci.org/leeper/rio)

## Examples ##

Because **rio** is meant to streamline data I/O, the package is extremely easy to use. Here are some examples of reading, writing, and converting data files.

### Export ###


```r
library("rio")
```

```
## Error in library("rio"): there is no package called 'rio'
```

```r
export(iris, "iris.csv")
```

```
## Error in eval(expr, envir, enclos): could not find function "export"
```

```r
export(iris, "iris.rds")
```

```
## Error in eval(expr, envir, enclos): could not find function "export"
```

```r
export(iris, "iris.dta")
```

```
## Error in eval(expr, envir, enclos): could not find function "export"
```

### Import ###


```r
library("rio")
```

```
## Error in library("rio"): there is no package called 'rio'
```

```r
x <- import("iris.csv")
```

```
## Error in eval(expr, envir, enclos): could not find function "import"
```

```r
y <- import("iris.rds")
```

```
## Error in eval(expr, envir, enclos): could not find function "import"
```

```r
z <- import("iris.dta")
```

```
## Error in eval(expr, envir, enclos): could not find function "import"
```

```r
# confirm identical
identical(iris, x)
```

```
## Error in identical(iris, x): object 'x' not found
```

```r
identical(x, y)
```

```
## Error in identical(x, y): object 'x' not found
```

```r
identical(y, z)
```

```
## Error in identical(y, z): object 'y' not found
```

### Convert ###


```r
library("rio")
```

```
## Error in library("rio"): there is no package called 'rio'
```

```r
convert("iris.csv", "iris.dta")
```

```
## Error in eval(expr, envir, enclos): could not find function "convert"
```


