CC = gcc
CFLAGS = -g 
ARFLAGS = rv
LIB = myutil
STATIC = lib$(LIB).a
SHARED = lib$(LIB).so
PROG = mathtest

all : $(STATIC) $(PROG)

$(PROG): $(PROG).o $(STATIC)
	$(CC) $(CFLAGS) -o $@ $< -L. -l$(LIB)

$(STATIC): squareit.o cubeit.o
	ar $(ARFLAGS) $(STATIC) $^
	ranlib $(STATIC)

$(PROG).o: $(PROG).c $(LIB).h
	$(CC) $(CFLAGS) -c $<

squareit.o: squareit.c $(LIB).h
	$(CC) $(CFLAGS) -c $<

cubeit.o: cubeit.c $(LIB).h 
	$(CC) $(CFLAGS) -c $<

static: $(PROG).o $(STATIC)
	$(CC) $(CFLAGS) -static -o $(PROG).static $< -L. -l$(LIB)

$(SHARED): squareit.o cubeit.o
	$(CC) $(CFLAGS) -shared $^ -o $@

shared: $(SHARED)
	$(CC) $(CFLAGS) -o $(PROG).shared $(PROG).o -L. -l$(LIB)
clean cls:
	rm -f $(PROG) $(PROG).static $(PROG).shared $(STATIC) $(SHARED) *.o *~ \#*
ci:
	if [! -d RCS ] ; then mkdir RCS; fi
	ci -t-none -m"lazy-checkin" -l *.[ch] ?akefile
git gat get: 
	if [ ! -d .git ] ; then git init; fi
	git add *.[ch] ?akefile 
	git commit -m "my lazy git commit comment"

tar: 
	tar cvfz Inclass-${LOGNAME}.tar.gz *.[ch] ?akefile
zip:
	zip -v Inclass-${LOGNAME}.zip *.[ch] ?akefile
