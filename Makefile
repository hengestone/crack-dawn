# Makefile for dawn framework
# Copyright 2011-2012 Conrad Steenberg <conrad.steenberg@gmail.com>
# 
#   This Source Code Form is subject to the terms of the Mozilla Public
#   License, v. 2.0. If a copy of the MPL was not distributed with this
#   file, You can obtain one at http://mozilla.org/MPL/2.0/.

ifndef CRACKC
  CRACKC=crackc
 endif

ifndef PREFIX
  PREFIX=$(shell ldd `which crack` | grep -e 'libCrackLang'| sed  's/.*libCrackLang.* => \(.*\)\/lib\/libCrackLang.*/\1/g')
endif

VERSION=$(lastword $(shell crack --version))

INSTALLDIR=${PREFIX}/lib/crack-${VERSION}/dawn


all: test/test_scgi

tests: test/test_scgi

test/test_scgi: test/test_scgi.crk dawn/scgi.crk


% : %.crk
	$(CRACKC) -l $(PREFIX)/lib $<


install:
	mkdir -p ${INSTALLDIR}
	install -C -D -d dawn ${INSTALLDIR}

clean:
	rm -fv $(tests) test/*.o test/*~ dawn/*.o
