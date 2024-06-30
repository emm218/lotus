M_SRC:=$(wildcard game/*.c)
SRC+=$(M_SRC)

all: target/game.so

target/game.so: CFLAGS+=-fPIC
target/game.so: $(M_SRC:.c=.o)
	@mkdir -p target
	$(LINK.c) $(LDLIBS) -shared $^ -o $@
