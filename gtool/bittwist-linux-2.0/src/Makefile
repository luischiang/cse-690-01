SHELL = /bin/sh

prefix = /usr
exec_prefix = ${prefix}
bindir = ${exec_prefix}/bin
mandir = ${prefix}/share/man/man1

CC ?= gcc
DEBUG = -g
CFLAGS ?= -O2
CFLAGS += $(DEBUG)
DOC = doc

INSTALL = /usr/bin/install -c
INSTALL_PROGRAM = ${INSTALL}
INSTALL_DATA = ${INSTALL} -m 644

all: bittwistx

bittwist:
	$(CC) $(CFLAGS) bittwist.c -o bittwist -I/usr/local/include -L/usr/local/lib -lpcap

bittwistx:
	$(CC) $(CFLAGS) bittwistx.c -o bittwistx -I/usr/local/include -L/usr/local/lib -lpcap
	
bittwiste:
	$(CC) $(CFLAGS) bittwiste.c -o bittwiste -I/usr/local/include -L/usr/local/lib -lpcap

clean:
	rm -f bittwistx 
