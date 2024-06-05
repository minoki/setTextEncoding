all: setTextEncoding
.PHONY: all

setTextEncoding: setTextEncoding.m
	$(CC) -o $@ -Wall -std=c99 $< -framework CoreFoundation -framework Foundation
