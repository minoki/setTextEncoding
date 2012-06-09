all: setTextEncoding

setTextEncoding: setTextEncoding.m
	gcc -o $@ -Wall -std=c99 $< -framework CoreFoundation -framework Foundation
