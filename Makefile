PROG =	minor-mercury

SRCS =	command.for dhms.for geo_car.for get_pid.for minor-mercury.for \
	mfo_user.for moyen_mouvement.for timestamp.for

OBJS =	command.o dhms.o geo_car.o get_pid.o minor-mercury.o mfo_user.o \
	moyen_mouvement.o timestamp.o

LIBS = -lm	

CC = gcc
CFLAGS = -O
FC = gfortran
#FC = ifort
FFLAGS = -O -mcmodel=medium
F90 = gfortran
#F90 = ifort
F90FLAGS = -O
LDFLAGS = -s

all: $(PROG)

$(PROG): $(OBJS)
	$(FC) $(LDFLAGS) -o $@ $(OBJS) $(LIBS)

clean:
	rm -f $(PROG) $(OBJS) *.mod *.d

.SUFFIXES: $(SUFFIXES) .f .for

.f90.o:
	$(F90) $(F90FLAGS) -c $<

.f.o:
	$(FC) $(FFLAGS) -c $<

.for.o:
	$(FC) $(FFLAGS) -c $<

.c.o:
	$(CC) $(CFLAGS) -c $<

geo_car.o: mercury.inc
minor-mercury.o: mercury.inc mercury.inc mercury.inc mercury.inc mercury.inc \
	mercury.inc mercury.inc mercury.inc mercury.inc mercury.inc \
	mercury.inc mercury.inc mercury.inc mercury.inc mercury.inc \
	mercury.inc mercury.inc mercury.inc mercury.inc mercury.inc \
	mercury.inc mercury.inc mercury.inc mercury.inc mercury.inc \
	mercury.inc mercury.inc mercury.inc mercury.inc mercury.inc \
	mercury.inc mercury.inc mercury.inc mercury.inc mercury.inc \
	mercury.inc mercury.inc mercury.inc mercury.inc mercury.inc \
	mercury.inc mercury.inc mercury.inc mercury.inc mercury.inc \
	mercury.inc swift.inc swift.inc swift.inc swift.inc swift.inc \
	swift.inc swift.inc swift.inc swift.inc swift.inc swift.inc \
	mercury.inc mercury.inc mercury.inc mercury.inc mercury.inc \
	mercury.inc mercury.inc mercury.inc mercury.inc mercury.inc \
	mercury.inc mercury.inc mercury.inc mercury.inc mercury.inc \
	mercury.inc mercury.inc mercury.inc mercury.inc mercury.inc \
	mercury.inc mercury.inc mercury.inc mercury.inc mercury.inc \
	mercury.inc mercury.inc mercury.inc mercury.inc mercury.inc \
	mercury.inc mercury.inc mercury.inc mercury.inc mercury.inc \
	mercury.inc mercury.inc mercury.inc mercury.inc mercury.inc \
	mercury.inc mercury.inc mercury.inc mercury.inc mercury.inc \
	mercury.inc mercury.inc mercury.inc mercury.inc mercury.inc \
	mercury.inc
mfo_user.o: mercury.inc
