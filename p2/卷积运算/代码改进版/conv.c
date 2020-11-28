#include<stdio.h>
int main()
{
	int n1,m1,n2,m2;
	scanf("%d%d%d%d",&n1,&m1,&n2,&m2);
	
	for(i=1;i<=n1;i++)
		for(j=1;j<=m1;j++)
		scanf("%d",&matrix[i][j]);
		
	for(i=1;i<=n2;i++)
		for(j=1;j<=m2;j++)
		scanf("%d",&conv[i][j]);
	
	for(i=1;i<=n1-n2+1;i++)
		{
			for(j=1;j<=m1-m2+1;j++)
			{
				int sum = 0;
				for(k=1;k<=n2;k++)
					for(l=1;l<=m2;l++)
					sum = sum + conv[k][l]*matrix[i+k-1][j+l-1];
				printf("%d ",sum);
			}
			printf("\n");
		}
		return 0;	
}
