# Makefile for zombies
# $Header: /home/simonb/src/cvsroot/zombies/Makefile,v 1.7 1999/06/26 14:37:17 simonb Exp $

# ---- FILE LOCATIONS ----

PREFIX		= /usr/local
BINDIR		= ${PREFIX}/bin
MANDIR		= ${PREFIX}/man/man6
SCOREFILE	= /var/games/zombies_score
BINOWN		= games
BINGRP		= games
BINMODE		= 2555
MANOWN		= root
MANGRP		= wheel
MANMODE		= 444
SCOREMODE	= 664

# ---- COMPILER OPTIONS ----

# Use gcc
CC		= gcc
# Use cc
#CC		= cc

# For gcc with all sorts of checks
FLAGS		= -O2 -Wall -Wstrict-prototypes -Wmissing-prototypes \
		  -Wpointer-arith -Wreturn-type -Wcomment -Waggregate-return \
		  -Wunused -Wbad-function-cast -Wcast-align -Wcast-qual \
		  -Wchar-subscripts -Winline -Wmissing-declarations \
		  -Wpointer-arith -Wshadow
# For almost everything else
#FLAGS		= -O2

# 'Most everything uses void signal handlers
SIG		= -DSIGTYPE=void
# And some ancient systems don't.
#SIG		= -DSIGTYPE=int

# ---- LIBRARIES ----

# Older BSDs need -ltermcap
LIBS		= -lcurses -ltermcap
# Newer BSDs and SysV use just curses
#LIBS		= -lcurses
# ncurses need -DUSE_NCURSES as well
#LIBS		= -lncurses
#DEFS		= -DUSE_NCURSES

# ---- INSTALLATION PROGRAMS ----

# BSDish
INSTALL_PROG	= install -c -s -o ${BINOWN} -g ${BINGRP} -m ${BINMODE}
INSTALL_MAN	= install -c -o ${MANOWN} -g ${MANGRP} -m ${MANMODE}
INSTALL_SCORE	= install -c -o ${BINOWN} -g ${BINGRP} -m ${SCOREMODE}

# SysVish
#INSTALL_PROG	= install -u ${BINOWN} -g ${BINGRP} -m ${BINMODE}
#INSTALL_MAN	= install -u ${MANOWN} -g ${MANGRP} -m ${MANMODE}
#INSTALL_SCORE	= install -u ${BINOWN} -g ${BINGRP} -m ${SCOREMODE}

# You shouldn't need to change anything beyond here...

PROG		= zombies
SRCS		= level.c main.c misc.c move.c score.c
HDRS		= zombies.h
MAN		= zombies.6
OBJS		= ${SRCS:.c=.o}
CFLAGS		= $(FLAGS) $(DEFS) -DSCORE_FILE=\"${SCOREFILE}\"

all:		$(PROG)

zombies:	${OBJS}
		${CC} -o $@ ${OBJS} ${LIBS}

${OBJS}:	${HDRS}

install:	${PROG}
		${INSTALL_PROG} ${PROG} ${BINDIR}
		${INSTALL_MAN} ${MAN} ${MANDIR}
		if [ ! -f ${SCOREFILE} ]; then \
			${INSTALL_SCORE} /dev/null ${SCOREFILE} ; \
		fi

clean:
		rm -f ${OBJS}

veryclean:	clean
		rm -f zombies
