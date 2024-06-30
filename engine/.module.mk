M_SRC:=$(wildcard engine/*.c)
SRC+=$(M_SRC)

all: bin/engine

bin/engine: $(M_SRC:.c=.o)
