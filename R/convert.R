convert <- function(in_file, out_file, in_opts=list(), out_opts=list()) {
    invisible(do.call("export", c(list(file = out_file, x = do.call("import", c(list(file=in_file), in_opts))), out_opts)))
}
