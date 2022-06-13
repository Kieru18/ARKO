//-------------------------------------------------------------------------------
// author: Jakub Kieruczenko
// date : 2022.06.11
// description : Turtle graphics version 2.
//-------------------------------------------------------------------------------

#include "image.c"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct{
	unsigned int x, y, ud, d;		
	unsigned char colors[3];			//blue, green, red
}Turtle;
 
extern int get_x(unsigned char *instruction);
extern int get_y(unsigned char *instruction);
extern int get_pen_state(unsigned char *instruction);
extern int get_distance(unsigned char *instruction);
extern int get_direction(unsigned char *instruction);
extern int get_red(unsigned char *instruction);
extern int get_green(unsigned char *instruction);
extern int get_blue(unsigned char *instruction);

extern void set_pixel(unsigned char* colors, unsigned char* dst);
extern int read_command(unsigned char* command);

void move(Turtle* turtle, unsigned char* command, ImageInfo* base);
void set_position(Turtle* turtle, unsigned char* command);
void set_direction(Turtle* turtle, unsigned char* command);
void set_pen_state(Turtle* turtle, unsigned char* command);


int main()
{
	unsigned char buffer[512] = {0};
	unsigned char command[2] = {0}; 
	unsigned int command_code = 0;
	
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
	
	Turtle* turtle;
	turtle = (Turtle*)malloc(sizeof(Turtle));
	if(!turtle)
	{
		perror("Allocation of memory for turtle failed");
		exit(-2);
	}
	
	int i=0;
	for(; i<len; i+=2)
	{
		command[0] = buffer[i+1];
		command[1] = buffer[i];
		
		command_code = read_command(command);
		
		switch(command_code)
		{
			case 0:		
				i+=2;	//skip to second word of command
				command[0] = buffer[i+1];
				command[1] = buffer[i];
				//printf("SET POSITION \n");
				set_position(turtle, command);
				break;
			case 1:
				//printf("SET DIRECTION \n");
				set_direction(turtle, command);
				break;
			case 2:
				//printf("MOVE \n");
				move(turtle, command, base);
				break;
			case 3:
				//printf("SET PEN STATE \n");
				set_pen_state(turtle, command);
				break;
			//default:
				//it doesnt exist, as all 4 combinations of 2 bits have been covered
				//break
		}
	}
	int check = saveBmp(ofname, base);
	
	freeImage(base);
	free(ptr);
	
	return 0;
}

void move(Turtle* turtle, unsigned char* command, ImageInfo* base)
{
	unsigned int distance = get_distance(command);
	unsigned int offset = 0;
	unsigned int out_of_bonds = 0;
	//printf("distance=%d \n", distance);
	for(int i=0; i<distance; ++i)
	{
		if(turtle->ud == 1)
		{
			offset = (turtle->x)*3 + (turtle->y)*(base->line_bytes);
			set_pixel(turtle->colors, base->pImg + offset);
		}
		switch(turtle->d)
		{
			case 0:		//right
				turtle->x++;
				if(turtle->x >= 768)
				{
					turtle->x = 767;
					return;
				}
				break;
				
			case 1:		//up
				turtle->y++;
				if(turtle->y >= 64)
				{
					turtle->y = 63;
					return;
				}
				break;
				
			case 2:		//left
				turtle->x--;
				if(turtle->x <= 0)
				{
					turtle->x = 0;
					return;
				}
				break;
				
			case 3:		//down
				turtle->y--;
				if(turtle->y <= 0)
				{
					turtle->y = 0;
					return;
				}
				break;
			//default:
				//it doesnt exist, as all 4 combinations of 2 bits have been covered
				//break
		}
	}
	
	
}
void set_position(Turtle* turtle, unsigned char* command)
{
	turtle->x = get_x(command);
	turtle->y = get_y(command);
	if(turtle->x >= 768)
	{
		turtle->x = 767;
	}
	if(turtle->x < 0)
	{
		turtle->x = 0;
	}
	if(turtle->y >= 64)
	{
		turtle->y = 63;
	}
	if(turtle->y < 0)
	{
		turtle->y = 0;
	}
	
	//printf("x=%d ", turtle->x);
	//printf("y=%d \n", turtle->y);
}
void set_direction(Turtle* turtle, unsigned char* command)
{
	turtle->d = get_direction(command);
	//printf("direction=%d \n", turtle->d);
}
void set_pen_state(Turtle* turtle, unsigned char* command)
{
	turtle->ud = get_pen_state(command);
	//printf("pen state=%d ", turtle->ud);
	
	turtle->colors[0] = get_blue(command);
	turtle->colors[1] = get_green(command);
	turtle->colors[2] = get_red(command);
	//printf("red=%d ", turtle->colors[2]);
	//printf("green=%d ", turtle->colors[1]);
	//printf("blue=%d \n", turtle->colors[0]);
}
