# Extending rio

``` r
library(rio)
```

rio implements format-specific S3 methods for each type of file that can
be imported from or exported to. This happens via internal S3 generics,
`.import` and `.export`. It is possible to write new methods like with
any S3 generic (e.g., `print`).

As an example, `.import.rio_csv` imports from a comma-separated values
file. If you want to produce a method for a new filetype with extension
`myfile`, you simply have to create a function called
`.import.rio_myfile` that implements a format-specific importing routine
and returns a data.frame. rio will automatically recognize new S3
methods, so that you can then import your file using:
`import("file.myfile")`.

The way to develop `export` method is same: `.export.rio_csv`. The first
two parameters of `.export` are `file` (file name) and `x` (data frame
to be exported).

As general guidance, if an import method creates many attributes, these
attributes should be stored — to the extent possible — in variable-level
attributes fields. These can be gathered to the data.frame level by the
user via `gather_attrs`.

## Examples

### arff

The following example shows how the arff import and export methods are
implemented internally.

``` r
.import.rio_arff <- function(file, which = 1, ...) {
    foreign::read.arff(file = file)
}
.export.rio_arff <- function(file, x, ...) {
    foreign::write.arff(x = x, file = file, ...)
}
```

### ledger

This is the example from the `ledger` package (MIT) by Dr Trevor L David
.

``` r
.import.rio_ledger <- register # nolint
register <- function(file, ..., toolchain = default_toolchain(file), date = NULL) {
    .assert_toolchain(toolchain)
    switch(toolchain,
        "ledger" = register_ledger(file, ..., date = date),
        "hledger" = register_hledger(file, ..., date = date),
        "beancount" = register_beancount(file, ..., date = date),
        "bean-report_ledger" = {
            file <- .bean_report(file, "ledger")
            on.exit(unlink(file))
            register_ledger(file, ..., date = date)
        },
        "bean-report_hledger" = {
            file <- .bean_report(file, "hledger")
            on.exit(unlink(file))
            register_hledger(file, ..., date = date)
        }
    )
}
```
