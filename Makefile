all: R/sysdata.rda NAMESPACE 

NAMESPACE: R/*
	Rscript -e "devtools::document()"

R/sysdata.rda: data-raw/single.json
	Rscript data-raw/convert.R
	Rscript -e "devtools::build_readme()"	
