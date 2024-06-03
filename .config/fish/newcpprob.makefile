.PHONY: build clean run

CC = g++
CFLAGS = -g -std=gnu++17

EXECUTABLE = {{EXECUTABLE}}
SOURCE = {{SOURCE}}

build: $(EXECUTABLE)

$(EXECUTABLE): $(SOURCE)
	$(CC) $(CFLAGS) -o $@ $^

run: $(EXECUTABLE)
	./$(EXECUTABLE)

clean:
	rm -f $(EXECUTABLE)
	rm -rf $(EXECUTABLE).dSYM
