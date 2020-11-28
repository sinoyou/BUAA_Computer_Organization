#include<stdio.h>
int a[10][10];
int b[10][10];
int multi[10][10];
int n;
char space = ' ';
char enter = '\n';
int main()
{
	// input n;
	scanf("%d",&n);
	// input matrix
	input_matrix();
	// matrix_multipication
	matrix_multi();
	// output;
	output();
	return 0;
}

void input_matrix(){
	int i,j;
	for(i=1;i<=n;i++)
	{
		for(j=1;j<=n;j++)
		{
			scanf("%d",&a[i][j]);
		}
	}
	
	for(i=1;i<=n;i++)
	{
		for(j=1;j<=n;j++)
		{
			scanf("%d",&b[i][j]);
		}
	}
}
int vector_dot(int a1,int a2)
{
	int cnt = 0;
	for(i=1;i<=n;i++)
	ans = ans + a[a1][i]*b[i][a2];
}
void matrix_multi()
{
	int i,j;
	for(i=1;i<=n;i++)
		for(j=1;j<=n;j++)
		{
			multi[i][j] = vector_dot(i,j);
		}
}

void output()
{
	for(i=1;i<=n;i++)
	{
		for(j=1;j<=n;j++)
		printf("%d%c",multi[i][j],space);
		printf("%c",enter);
	}
	
}
