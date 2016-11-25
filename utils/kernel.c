#define VIDEO_ROWS	25
#define VIDEO_COLS	80

void _start(void)
{
	unsigned char *vmem = (unsigned char *)0xb8000;

	for (int i = 0; i < VIDEO_ROWS * VIDEO_COLS * 2; i+=2) {
		*(vmem+i) = 0x00;
		*(vmem+i+1) = 0x1F;
	}

	unsigned char name[] = "PolyHeart";
	write(name, 2, 35);

	while (1) ;
}

int strlen(unsigned char *msg)
{
	int l = 0;

	for ( ; *msg; ++msg, ++l) ;

	return l;
}

void write(unsigned char *msg, int row, int col)
{
	unsigned char *vmem = (unsigned char *)0xb8000;
	vmem += (2 * row * VIDEO_COLS + 2 * col);

	for (int i = 0; i < strlen(msg); i += 1) {
		*(vmem+2*i) = msg[i];
	}
}


