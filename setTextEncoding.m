// An utility to set text file encoding (com.apple.TextEncoding attribute)
// Copyright (c) 2011-2012 ARATA Mizuki
#include <stdio.h>
#include <sys/xattr.h>
#include <Foundation/Foundation.h>
#include <CoreFoundation/CoreFoundation.h>

int main (int argc, char const * const * argv) {
  if (argc <= 1) {
  	fprintf(stderr, "usage: %s [encoding] files...\n", argv[0]);
    return 1;
  }
  id pool = [NSAutoreleasePool new];
  NSString *charSetName = [NSString stringWithUTF8String:argv[1]];
  CFStringEncoding encoding = CFStringConvertIANACharSetNameToEncoding((CFStringRef)charSetName);
  if (encoding == kCFStringEncodingInvalidId) {
  	fprintf(stderr, "invalid encoding id\n");
    [pool release];
    return 1;
  } else {
    NSString *normalizedName = (NSString *)CFStringConvertEncodingToIANACharSetName(encoding);
    char buffer[256];
    int length = snprintf(buffer, sizeof(buffer), "%s;%u", [normalizedName UTF8String], (unsigned int)encoding);
    printf("%s\n", buffer);
    for (int i = 2; i < argc; ++i) {
      int error = setxattr(argv[i], "com.apple.TextEncoding", buffer, length, 0, 0);
      if (error < 0) {
        fprintf(stderr, "%s:%s\n", argv[i], strerror(errno));
        [pool release];
        return 1;
      }
    }
  }
  [pool release];
  return 0;
}

