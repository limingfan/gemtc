all: all-redirect

MPI_DIR = 
# Some systems may want to add -static to the MPICC line
MPICC   = /Users/gropp/bin/mpicc
#MPIF77  = @MPIF77@
#MPIEXEC = @MPIEXEC@
#MPIEXEC_NP = @MPIEXEC_NP@
PNCDIR  = 

# _XOPEN_SOURCE ensures that drand48 and friends are defined in stdlib.h
# _POSIX_C_SOURCE=199506L and HAVE_NANOSLEEP should be set if
# nanosleep is available
#CFLAGS+= -g -O0 -Wall -D_XOPEN_SOURCE -D_POSIX_C_SOURCE=199506L -DHAVE_NANOSLEEP
CPPFLAGS = -DHAVE_CONFIG_H
CFLAGS = -g -O2

MLIFEOBJS = mlife2d.o patch.o moptions.o mlife2d-io-stdout1.o mtiming.o \
	mlife2d-pt2pt.o mlife2d-pt2ptsnd.o mlife2d-pt2ptuv.o mlife2d-fence.o \
	mlife2d-pt2pt9.o

.c.o:	$?
	$(MPICC) $(CFLAGS) $(CPPFLAGS) -c $(?) -o $(@)
.f.o:   $?
	$(MPIF77) $(FFLAGS) -c $(?) -o $(@)

EXECS = mlife2d

default: mlife2d

all-redirect: $(EXECS)

mlife2d: $(MLIFEOBJS)
	$(MPICC) $(CFLAGS) -o $@ $(LDFLAGS) $(MLIFEOBJS) $(LIBS)

#mlife2d-fpmpi: mlife2d.o mlife2d-io-stdout.o mlife2d-pt2pt.o
#	$(MPICC) $(CFLAGS) -o mlife2d-fpmpi $(LDFLAGS) mlife2d.o mlife2d-io-stdout.o mlife2d-pt2pt.o -L -lfpmpi $(LIBS)

Makefile: Makefile.in config.status
	./config.status

clean::
	rm -f *.o *.ps *.pdf $(EXECS) $(OMPEXECS) \
		fpmpi_profile.txt *.chkpt *.exe *.stackdump

realclean: clean
	rm -f config.log config.status 
	rm -rf autom4te.cache
