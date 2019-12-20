pkg = $(shell basename $(CURDIR))

all: build

NAMESPACE: R/*
	Rscript -e "devtools::document()"

README.md: README.Rmd
	Rscript -e "knitr::knit('README.Rmd')"

README.html: README.md
	pandoc -o README.html README.md

../$(pkg)*.tar.gz: DESCRIPTION NAMESPACE README.md R/* man/* tests/testthat/* po/R-rio.pot
	cd ../ && R CMD build $(pkg)

build: ../$(pkg)*.tar.gz

check: ../$(pkg)*.tar.gz
	cd ../ && R CMD check $(pkg)*.tar.gz
	rm ../$(pkg)*.tar.gz

install: ../$(pkg)*.tar.gz
	cd ../ && R CMD INSTALL $(pkg)*.tar.gz
	rm ../$(pkg)*.tar.gz

website: R/* README.md DESCRIPTION
	Rscript -e "pkgdown::build_site()"

po/R-rio.pot: R/* DESCRIPTION
	Rscript -e "tools::update_pkg_po('.')"

translations: po/R-rio.pot
