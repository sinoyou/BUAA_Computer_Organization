#include<stdio.h>

int n;
int stack[21];
int main()
{
	scanf("%d",&n);
	int i;
	char c;
	for(i=1;i<=n/2;i++)
	{
		scanf("%c",&c);
		stack[i] = c;
	}
	// 去处中间的数 
	if(n%2==1)scanf("%c",&c);
	for(i=n/2;i>=1;i--)
	{
		scanf("%c",&c);
		if(c!=stack[i]){
			fail();
			return;
		}
	}
	printf("1");
	return 0;
} 
