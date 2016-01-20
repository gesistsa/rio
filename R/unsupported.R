stop_for_import <- function(fmt) {
    x <- "%s format not supported. Consider using the `%s` function"
    switch(fmt,
           gnumeric = sprintf(x, fmt, "gnumeric::read.gnumeric.sheet"),
           jpg = sprintf(x, fmt, "jpeg::readJPEG"),
           png = sprintf(x, fmt, "png::readPNG"),
           png = sprintf(x, fmt, "bmp::read.bmp"),
           tiff = sprintf(x, fmt, "tiff::readTIFF"),
           sss = sprintf(x, fmt, "sss::read.sss"),
           sdmx = sprintf(x, fmt, "sdmx::readSDMX"),
           matlab = sprintf(x, fmt, "R.matlab::readMat"),
           gexf = sprintf(x, fmt, "rgexf::read.gexf"),
           npy = sprintf(x, fmt, "RcppCNPy::npyLoad"),
           fmt)
}

stop_for_export <- function(fmt) {
    x <- "%s format not supported. Consider using the `%s` function"
    switch(fmt,
           jpg = sprintf(x, fmt, "jpeg::writeJPEG"),
           png = sprintf(x, fmt, "png::writePNG"),
           tiff = sprintf(x, fmt, "tiff::writeTIFF"),
           matlab = sprintf(x, fmt, "R.matlab::writeMat"),
           xpt = sprintf(x, fmt, "SASxport::write.xport"),
           gexf = sprintf(x, fmt, "rgexf::write.gexf"),
           npy = sprintf(x, fmt, "RcppCNPy::npySave"),
           fmt)
}
