

void io_hlt(void);
void write_mem8(int addr,int data);

/**
* X‰ü“üŒû”Ÿ”
****/
void LongMain(void)
{
	int i;
	char *p;
	for(i=0xa0000;i<0xaffff;i++){
		p=(char *)i;
		*p = i&0x0f;
		//write_mem8(i,i&0x0f);
	}
	
	for(;;){
		io_hlt();
	}

}
