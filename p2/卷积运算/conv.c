#include<stdio.h>
int m1,n1,m2,n2;
int matrix[15][15], cell[15][15];
int conv[15][15];

int main()
{
	scanf("%d%d%d%d",&m1,&n1,&m2,&n2);
	input();
	for(i=1;i<=m1-m2+1;j++)
	{
		for(j=1;j<=n1-n2+1;j++)
		{
			int value = conv_calc(i,j);
			conv[i][j] = value;
		}
	}
	output();
	return 0;
}

int conv_calc(int a0,int a1)
{
	for(i=1;i<=m2;i++)
	{
		for(j=1;j<=n2;j++)
		{
			sum += matrix[a0+i-1][a1+j-1]*cell[i][j];
		}
	}
	return sum;
}

void input(int array[],int a1,int a2)
{
	for(i=1;i<=a1;i++)
	{
		for(j=1;j<=a2;j++)
		scanf("%d",&array[i][j]);
	}
}

void output()
{
	for(i=1;i<=m1-m2+1;i++)
	{
		for(j=1;j<=n1-n2+1;j++)
		{
			printf("%d ",conv[i][j]);
		}
		printf("\n");
	}
	
}
