#include<stdio.h>
char ins[60][10]={"0",
				  "add","addu","sub","subu",
				  "sll","srl","sra","sllv","srlv","srav",
				  "and","or","xor","nor",
				  "slt","sltu",
				  "mult","multu","div","divu",
				  "mthi","mtlo","mfhi","mflo",
				  "addi","addiu","andi","ori",
				  "xori","lui","slti","stliu",
				  "lw","lb","lbu","lh","lhu",
				  "sw","sh","sb",
				  "beq","bne","blez","bgtz","bltz","bgez",
				  "j","jal","jr","jalr"};
int main()
{
	freopen("1.txt","r",stdin);
	freopen("2.txt","w",stdout);
	char s[100];
	int i = 0;
	while(scanf("%s",s)!=EOF){
		i = i + 1;
		printf("IR = 32'h%s;\n",s);
		printf("#5;\n");
		printf("$display(\"Pipe 4; AT-%s:Tuse_Rs=%%d; Tuse_Rt=%%d; RWNZ=%%d; A3=%%d; Tnew=%%d; DPort=%%d;\",Tuse_Rs,Tuse_Rt,RegWriteNonZero,A3,Tnew,DPort);\n",ins[i]);
		printf("#10;\n");
	}
	return 0;
}
