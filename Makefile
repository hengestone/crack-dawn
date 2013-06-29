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

tests=test/test_scgi test/test_user test/test_user_c test/test_echo
libs=dawn/jsonrpc.crk dawn/scgi.crk

VERSION=$(lastword $(shell crack --version))
MONGO_CFLAGS=`pkg-config --cflags libmongo-client`
MONGO_LIBS=`pkg-config --libs libmongo-client`

INSTALLDIR=${PREFIX}/lib/crack-${VERSION}/dawn


all: bin/crack_scgi dawn/user.crk

tests: test/test_echo test/test_scgi test/test_user test/test_user_c

test/test_scgi: test/test_scgi.crk $(libs)
test/test_echo: test/test_echo.crk $(libs)
test/test_user: interfaces/user.whipdl \
                 test/test_user.crk dawn/user.crk \
                 dawn/mongo_user.crk
bin/crack_scgi: bin/crack_scgi.crk $(libs)

test/test_user_c : test/test_user.c
	gcc $< ${MONGO_CFLAGS} -o $@ ${MONGO_LIBS}

dawn/user.crk: interfaces/user.whipdl
	whipclass -i $< -l crack -s bson -o $@


% : %.crk
	$(CRACKC) -l $(PREFIX)/lib $<


install:
	mkdir -p ${INSTALLDIR}
	install -C -D -d dawn ${INSTALLDIR}

clean:
	rm -fv $(tests) test/*.o test/*~ dawn/*.o bin/crack_scgi bin/crack_scgi.o
