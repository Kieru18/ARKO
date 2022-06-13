#include "image.h"
#include "image.c"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern "C" ImageInfo* turtle2(unsigned char *instructions, ImageInfo *imageinfo, unsigned int intruction_size);


int main()
{
	unsigned char buffer[512];
	FILE *ptr;
	const char ifname[] = "turtle2.bin";
	const char ofname[] = "turtle2.bmp";
	const char basename[] = "base.bmp";
	
	ImageInfo* base = readBmp(basename);
	
	ptr = fopen(ifname, "rb");
	
	if(ptr == NULL)
	{
		printf("error reading file");
		return 0;
	}
	
	fseek(ptr, 0L, SEEK_END);
	int len = ftell(ptr);
	rewind(ptr);
	fread(buffer, len, 1, ptr);
	for(int i=0; i<len; i+=2)
	{
		printf("%x", buffer[i]);
		printf("%x ", buffer[i+1]);
	}
	printf("\n");
	
	ImageInfo* modified = turtle2(buffer, base, len);
	
	int check = saveBmp(ofname, modified);
	
	freeImage(base);
	
	
	return 0;
}
