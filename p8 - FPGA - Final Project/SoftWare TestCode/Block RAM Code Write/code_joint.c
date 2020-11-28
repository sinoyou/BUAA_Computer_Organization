#include<string.h>
#include<stdio.h>
// 0x4180 - 0x3000 = 1120 * 4
char code[20];
char nop[20]="00000000";
int main()
{
	freopen("code.txt","r",stdin);
	freopen("joint.txt","w",stdout);
	int i=0;
	while(scanf("%s",code)!=EOF){
		i = i+1;
		printf("%s\n",code);
	}
	for(;i<1120;i++){
		printf("%s\n",nop);
	}
	freopen("code_handler.txt","r",stdin);
	while(scanf("%s",code)!=EOF){
		i = i+1;
		printf("%s\n",code);
	}
	return 0;
}
