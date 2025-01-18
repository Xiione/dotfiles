.PHONY: build clean run

CC := g++
CFLAGS := -g -std=gnu++17 -D DLOCAL -I/Library/Developer/CommandLineTools/usr/include

PROBNAME := $(shell basename $(CURDIR))
EXECUTABLE := $(PROBNAME)
SOURCE := $(PROBNAME).cpp

build: $(EXECUTABLE)

$(EXECUTABLE): $(SOURCE)
	$(CC) $(CFLAGS) -o $@ $^

run: $(EXECUTABLE)
	./$(EXECUTABLE) | grep --color=always -e ".*" 

clean:
	rm -f $(EXECUTABLE)
	rm -rf $(EXECUTABLE).dSYM
