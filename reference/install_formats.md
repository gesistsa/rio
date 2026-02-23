# Install rio's ‘Suggests’ Dependencies

Not all suggested packages are installed by default. These packages are
not installed or loaded by default in order to create a slimmer and
faster package build, install, and load. Use
`show_unsupported_formats()` to check all unsupported formats.
`install_formats()` installs all missing ‘Suggests’ dependencies for rio
that expand its support to the full range of support import and export
formats.

## Usage

``` r
install_formats(...)

show_unsupported_formats()
```

## Arguments

- ...:

  Additional arguments passed to
  [`utils::install.packages()`](https://rdrr.io/r/utils/install.packages.html).

## Value

For `show_unsupported_formats()`, if there is any missing unsupported
formats, it return TRUE invisibly; otherwise FALSE. For
`install_formats()` it returns TRUE invisibly if the installation is
succuessful; otherwise errors.

## Examples

``` r
# \donttest{
if (interactive()) {
    install_formats()
}
# }
```
