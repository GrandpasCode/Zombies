# Makefile for zombies
# $Header: /home/simonb/src/cvsroot/zombies/Makefile,v 1.7 1999/06/26 14:37:17 simonb Exp $

# ---- FILE LOCATIONS ----

PREFIX		= /usr/local
BINDIR		= $(PREFIX)/bin
MANDIR		= $(PREFIX)/man/man6
SCOREFILE	= $(PREFIX)/var/games/zombies_score
BINOWN		= games
BINGRP		= games
BINMODE		= 2555
MANOWN		= root
MANGRP		= wheel
MANMODE		= 444
SCOREMODE	= 664

# ---- COMPILER OPTIONS ----

CC		?= gcc
CFLAGS		?= -O2
CFLAGS		+= -std=c99 -Wall -Wextra
CFLAGS		+= $(shell ncurses5-config --cflags)
CPPFLAGS	+= -D_POSIX_C_SOURCE=200112L -DSCORE_FILE='"$(SCOREFILE)"'
LDLIBS		+= $(shell ncurses5-config --libs)

# ---- INSTALLATION PROGRAMS ----

INSTALL_PROG	= install -c -s -o $(BINOWN) -g $(BINGRP) -m $(BINMODE)
INSTALL_MAN	= install -c -o $(MANOWN) -g $(MANGRP) -m $(MANMODE)
INSTALL_SCORE	= install -c -o $(BINOWN) -g $(BINGRP) -m $(SCOREMODE)

# You shouldn't need to change anything beyond here...

PROG		= zombies
SRCS		= $(wildcard *.c)
HDRS		= zombies.h
MAN		= zombies.6
OBJS		= $(SRCS:.c=.o)

all:		$(PROG)
.PHONY: all

$(PROG):	$(OBJS)

%.o:		%.c $(HDRS)

install:	$(PROG)
		$(INSTALL_PROG) $(PROG) $(BINDIR)
		$(INSTALL_MAN) $(MAN) $(MANDIR)
		if [ ! -f $(SCOREFILE) ]; then \
			$(INSTALL_SCORE) /dev/null $(SCOREFILE) ; \
		fi
.PHONY: install

clean:
		$(RM) $(OBJS)
.PHONY: clean

clobber:	clean
		$(RM) $(PROG)
.PHONY: clobber
