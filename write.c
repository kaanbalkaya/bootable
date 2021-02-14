#include <stdio.h>
#include <stdlib.h>
#define BMP_HEADER_SIZE 1078
#define DATA 64000  //320*200 pixel resmin niteliği biliniyor



FILE *resim_fp, 
     *disket_fp,
     *boot_fp;  	
  

int dosya_ac();
void boot_yaz();
void resim_yaz();

int main(int argc,char *argv[])
{
	int hata;
	hata=dosya_ac();
	if(hata)
	{
		printf("\nHata!!!");
		return -1;
	}
	boot_yaz();	
	resim_yaz();
	fclose(resim_fp);
	fclose(boot_fp);
	fclose(disket_fp);
}

int dosya_ac()
{	
	
	resim_fp=fopen("resim.bmp","rb");
	if(resim_fp==NULL)
	{
		printf("bmp acilamadi");
		return -1;
	}
	fseek(resim_fp,BMP_HEADER_SIZE,SEEK_SET);  //bitmap bilgisinin başladığı yer
	
	boot_fp=fopen("boot","rb");
	if(resim_fp==NULL)
	{
		printf("boot acilamadi");
		return -1;
	}
	fseek(boot_fp,0L,SEEK_SET);
		
	disket_fp=fopen("/dev/fd0","wb");
	if(disket_fp==NULL)
	{
		printf("disket acilamadi");
		return -1;
	}
	fseek(disket_fp,0L,SEEK_SET);
	
	return 0;
}



void boot_yaz()
{
	char boot_buf[512];
	
	fread(boot_buf,510,1,boot_fp);         //boot bin dosyasından 510 byte okundu

	boot_buf[510]=0x55;	//boot imzası olan 0x55aa
	boot_buf[511]=0xaa;
	
	fwrite(boot_buf,512,1,disket_fp);
}	
	
	
	
void resim_yaz()
{
	char resim_buf[DATA];
	
	while(!feof(resim_fp))
	{	
		
		fread(resim_buf,1,1,resim_fp);
		fwrite(resim_buf,1,1,disket_fp);
	}

}
