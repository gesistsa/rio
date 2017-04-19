pkg = $(shell basename $(CURDIR))

all: build

NAMESPACE: R/
	Rscript -e "devtools::document()"

README.md: README.Rmd
	Rscript -e "knitr::knit('README.Rmd')"

README.html: README.md
	pandoc -o README.html README.md

../$(pkg)*.tar.gz: DESCRIPTION NAMESPACE
	cd ../ && R CMD build $(pkg)

build: ../$(pkg)*.tar.gz

check: ../$(pkg)*.tar.gz
	cd ../ && R CMD check $(pkg)*.tar.gz --no-multiarch
	rm ../$(pkg)*.tar.gz

install: ../$(pkg)*.tar.gz
	cd ../ && R CMD INSTALL $(pkg)*.tar.gz
	rm ../$(pkg)*.tar.gz
