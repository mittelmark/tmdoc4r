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
	@printf "   make build   pkg=sbi\n      for creating a true R package file named sbi_�(VERSION).tar.gz\n"
	@printf "   make install pkg=sbi\n      for installing the package file sbi_$(VERSION).tar.gz\n"
build:
	-rm -rf $(pkg)/ temp
	-rm -f $(pkg)_$(VERSION).tar.gz
	Rscript $(pkg)-src.R --process $(pkg)-src.R
	Rscript $(pkg)-src.R --vignettex $(pkg)-src.R
	mv $(pkg)/vignettes temp
	mkdir $(pkg)/inst/doc
	mkdir $(pkg)/vignettes
	tmdoc tmdoc4r-examples.Rmd - | mndoc - $(pkg)/inst/doc/$(pkg)-examples.html --css examples/tmdoc.css
	tmdoc tmdoc4r-vignette.Rmd - --toc true > /dev/null
	tmdoc tmdoc4r-vignette.Rmd - --toc true | mndoc - $(pkg)/inst/doc/$(pkg)-vignette.html --css examples/tmdoc.css --mathjax true
	mndoc $(pkg)/inst/doc/$(pkg)-vignette.html $(pkg)/inst/doc/tmdoc4r-vignette.pdf
	mv $(pkg)/inst/doc/tmdoc4r-vignette.pdf $(pkg)/vignettes/
	cp tmdoc4r-vignette.Rnw  $(pkg)/vignettes/
	cp examples/tmdoc.css $(pkg)/inst/files/
	mv $(pkg)/inst/doc/*.html .
	#cp tmdoc4r-examples.Rmd tmdoc4r-vignette.Rmd $(pkg)/vignettes/
	TMPDIR=`pwd`/Rbuild R_LIBS=`pwd`/$(pkg).Rcheck Rscript $(pkg)-src.R --build $(pkg)
	# prepare the documented TeX-less fallback (R CMD build --no-build-vignettes):
	# without a populated inst/doc that build ships no vignette index, so the
	# installed package has no Meta/vignette.rds and vignette() fails. A full
	# build (CI) has already written its own products into inst/doc and its
	# tarball is already on disk, so these two lines only matter locally.
	cp $(pkg)/vignettes/$(pkg)-vignette.Rnw $(pkg)/vignettes/$(pkg)-vignette.pdf $(pkg)/inst/doc/
	# the source-tree PDF is consumed only by the Sweave \includepdf during
	# --build; drop it afterwards so the fallback tarball does not ship it twice
	rm -f $(pkg)/vignettes/*.pdf
	R_LIBS=`pwd`/$(pkg).Rcheck Rscript $(pkg)-src.R --check $(pkg)_$(VERSION).tar.gz
vignette:
	tmdoc tmdoc4r-vignette.Rmd - --toc true > /dev/null
	tmdoc tmdoc4r-vignette.Rmd - --toc true | mndoc - $(pkg)/inst/doc/$(pkg)-vignette.html --css examples/tmdoc.css --mathjax true
	mndoc $(pkg)/inst/doc/$(pkg)-vignette.html $(pkg)/inst/doc/tmdoc4r-vignette.pdf
	mv $(pkg)/inst/doc/tmdoc4r-vignette.pdf $(pkg)/vignettes/
book:
	tmdoc tmdoc4r-vignette.Rmd - --toc true > /dev/null
	tmdoc tmdoc4r-vignette.Rmd - --toc true | mndoc - tmdoc4r-tutorial-book.html --css book.css --mathjax true
	mndoc tmdoc4r-tutorial-book.html tmdoc4r-tutorial-book.pdf
install: build	
	Rscript $(pkg)-src.R --install $(pkg)_$(VERSION).tar.gz

ex:
	cd examples && R_LIBS=$(CURDIR)/$(pkg).Rcheck Rscript -e "library($(pkg));tmdoc('ex-01.tmd','ex-01.html',css='tmdoc.css');"
	cd examples && R_LIBS=$(CURDIR)/$(pkg).Rcheck Rscript -e "library($(pkg));tmdoc('ex-02.tmd','ex-02.html',css='tmdoc.css');"
	cd examples && R_LIBS=$(CURDIR)/$(pkg).Rcheck Rscript -e "library($(pkg));tmdoc('ex-03.Rmd','ex-03.html',css='tmdoc.css');"
	cd examples && R_LIBS=$(CURDIR)/$(pkg).Rcheck Rscript -e "library($(pkg));tmdoc('ex-04.pmd','ex-04.html',css='tmdoc.css');"
	cd examples && R_LIBS=$(CURDIR)/$(pkg).Rcheck Rscript -e "library($(pkg));tmdoc('ex-05.omd','ex-05.html',css='tmdoc.css');"
	cd examples && R_LIBS=$(CURDIR)/$(pkg).Rcheck Rscript -e "library($(pkg));tmdoc('ex-06.tmd','ex-06.html',css='tmdoc.css');"
	cd examples && R_LIBS=$(CURDIR)/$(pkg).Rcheck Rscript -e "library($(pkg));tmdoc('ex-07.tmd','ex-07.html',css='tmdoc.css');"
	cd examples && R_LIBS=$(CURDIR)/$(pkg).Rcheck Rscript -e "library($(pkg));tmdoc('ex-08.tmd','ex-08.html',css='tmdoc.css');"
	cd examples && R_LIBS=$(CURDIR)/$(pkg).Rcheck Rscript -e "library($(pkg));tmdoc('ex-09.tmd','ex-09.html',css='tmdoc.css');"	
	cd examples && R_LIBS=$(CURDIR)/$(pkg).Rcheck Rscript -e "library($(pkg));tmdoc('ex-10.tmd','ex-10.html',css='tmdoc.css');"	
	cd examples && R_LIBS=$(CURDIR)/$(pkg).Rcheck Rscript -e "library($(pkg));tmdoc('ex-11.tmd','ex-11.html',css='tmdoc.css',toc=TRUE);"		

clean:
	-rm -rf $(pkg)/
	-rm -rf $(pkg).Rcheck
	
