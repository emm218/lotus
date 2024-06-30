CC=clang

CFLAGS+=-Wall -Wextra -Werror -Iinclude
LDFLAGS+=-fuse-ld=lld

CLEAN:=rm -rf */*.o bin/* lib/*

MODULES:=engine

SRC:=

debug: CFLAGS+=-g -DDEBUG_FLAG
debug: all 

release: CFLAGS+=-O2 -flto
release: LDFLAGS+=-flto
release: clean all 

include $(patsubst %, %/.module.mk, $(MODULES))

bin/%:
	@mkdir -p bin
	$(LINK.c) $(LDLIBS) $^ -o $@

run: debug
	@./bin/engine

compile_commands.json: Makefile
	$(CLEAN)
	bear -- make --no-print-directory --quiet

.depend/%.d: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -MM $^ -MF $@ -MT $(^:.c=.o)

include $(patsubst %.c, .depend/%.d, $(SRC))

clean:
	$(CLEAN)

.PHONY: clean
