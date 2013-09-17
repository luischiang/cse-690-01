CC=gcc

CPLEXDIR = /opt/ibm/ILOG/CPLEX_Studio124/cplex/

COPT  = -m64 -fPIC -fno-strict-aliasing

CPLEXINCDIR   = $(CPLEXDIR)/include

CFLAGS  = $(COPT) -I$(CPLEXINCDIR)

CPLEXLIBDIR   = $(CPLEXDIR)/lib/x86-64_sles10_4.1/static_pic/

CLNFLAGS  = -L$(CPLEXLIBDIR) -lcplex -lm -pthread

all:ilpsolver lpsolver

mipex2.o:mipex2.c
	$(CC) $(CFLAGS) -c mipex2.c 

lpex2.o:lpex2.c
	$(CC) $(CFLAGS) -c lpex2.c 


lpsolver:lpex2.o
	$(CC) $(CFLAGS) lpex2.o -o lpsolver $(CLNFLAGS) 

ilpsolver:mipex2.o
	$(CC) $(CFLAGS) mipex2.o -o ilpsolver $(CLNFLAGS) 
