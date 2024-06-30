M_SRC:=$(wildcard engine/*.c)
SRC+=$(M_SRC)

all: target/engine

target/engine: LDLIBS+=-lglfw
target/engine: $(M_SRC:.c=.o) lib/glad.o
	@mkdir -p target
	$(LINK.c) $(LDLIBS) $^ -o $@
