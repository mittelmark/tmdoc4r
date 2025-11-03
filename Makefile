##-*- makefile -*-############################################################
#
# Copyright (C) 2025 MicroEmacs User.
#
# All rights reserved.
#
# Synopsis:    
# Authors:     MicroEmacs User
#
##############################################################################

CURRENT_MAKEFILE := $(lastword $(MAKEFILE_LIST))

## argument delegation
ARGS=

## default: list existing tasks 
pkg=tmdoc4r
VERSION=$(shell grep -Eo "^#' Version: [.0-9]+" $(pkg)-src.R | sed -E 's/.+: //g; s/ //g;')
help:
	@printf "Usage:\n"
	@printf "   make build   pkg=sbi\n      for creating a true R package file named sbi_§(VERSION).tar.gz\n" 
	@printf "   make install pkg=sbi\n      for installing the package file sbi_$(VERSION).tar.gz\n"
build:
	-rm -rf $(pkg)/ temp
	Rscript $(pkg)-src.R --process $(pkg)-src.R
	Rscript $(pkg)-src.R --vignettex $(pkg)-src.R
	mv $(pkg)/vignettes temp
	mkdir $(pkg)/inst/doc
	mkdir $(pkg)/vignettes
	tmdoc tmdoc4r-examples.Rmd - | mndoc - $(pkg)/inst/doc/$(pkg)-examples.html --css examples/tmdoc.css
	tmdoc tmdoc4r-vignette.Rmd - --toc true | mndoc - $(pkg)/inst/doc/$(pkg)-vignette.html --css examples/tmdoc.css 
	weasyprint -q --stylesheet small.css $(pkg)/inst/doc/$(pkg)-vignette.html $(pkg)/vignettes/tmdoc4r-vignette.pdf
	cp tmdoc4r-vignette.Rnw  $(pkg)/vignettes/
	cp examples/tmdoc.css $(pkg)/inst/files/
	rm $(pkg)/inst/doc/*.html
	#cp tmdoc4r-examples.Rmd tmdoc4r-vignette.Rmd $(pkg)/vignettes/
	R_LIBS=`pwd`/$(pkg).Rcheck/ Rscript $(pkg)-src.R --build $(pkg)
	R_LIBS=`pwd`/$(pkg).Rcheck/ Rscript $(pkg)-src.R --check $(pkg)_$(VERSION).tar.gz
vignette:
	tmdoc tmdoc4r-vignette.Rmd - --toc true | mndoc - $(pkg)/inst/doc/$(pkg)-vignette.html --css examples/tmdoc.css 
install: build	
	Rscript $(pkg)-src.R --install $(pkg)_$(VERSION).tar.gz

ex:
	cd examples && R_LIBS=`pwd`/$(pkg).Rcheck Rscript -e "library($(pkg));tmdoc('ex-01.tmd','ex-01.html',css='tmdoc.css');"
	cd examples && R_LIBS=`pwd`/$(pkg).Rcheck Rscript -e "library($(pkg));tmdoc('ex-02.tmd','ex-02.html',css='tmdoc.css');"
	cd examples && R_LIBS=`pwd`/$(pkg).Rcheck Rscript -e "library($(pkg));tmdoc('ex-03.Rmd','ex-03.html',css='tmdoc.css');"
	cd examples && R_LIBS=`pwd`/$(pkg).Rcheck Rscript -e "library($(pkg));tmdoc('ex-04.pmd','ex-04.html',css='tmdoc.css');"
	cd examples && R_LIBS=`pwd`/$(pkg).Rcheck Rscript -e "library($(pkg));tmdoc('ex-05.omd','ex-05.html',css='tmdoc.css');"
	cd examples && R_LIBS=`pwd`/$(pkg).Rcheck Rscript -e "library($(pkg));tmdoc('ex-06.tmd','ex-06.html',css='tmdoc.css');"
	cd examples && R_LIBS=`pwd`/$(pkg).Rcheck Rscript -e "library($(pkg));tmdoc('ex-07.tmd','ex-07.html',css='tmdoc.css');"
	cd examples && R_LIBS=`pwd`/$(pkg).Rcheck Rscript -e "library($(pkg));tmdoc('ex-08.tmd','ex-08.html',css='tmdoc.css');"
	cd examples && R_LIBS=`pwd`/$(pkg).Rcheck Rscript -e "library($(pkg));tmdoc('ex-09.tmd','ex-09.html',css='tmdoc.css');"	
	cd examples && R_LIBS=`pwd`/$(pkg).Rcheck Rscript -e "library($(pkg));tmdoc('ex-10.tmd','ex-10.html',css='tmdoc.css');"	
	cd examples && R_LIBS=`pwd`/$(pkg).Rcheck Rscript -e "library($(pkg));tmdoc('ex-11.tmd','ex-11.html',css='tmdoc.css',toc=TRUE);"		

clean:
	-rm -rf $(pkg)/
	-rm -rf $(pkg).Rcheck
	
