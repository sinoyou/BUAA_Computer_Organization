#include<stdio.h>
int n;
int visit[10],save[10];
void dfs(int depth)
{
	if(depth>n)
	{
		output();
		return;
	}
	for(i=1;i<=n;i++)
	{
		if(!visit[i])
		{
			visit[i] = 1;
			save[depth] = i; 
			dfs(depth+1);
			visit[i] = 0;
		}
	}
}
void output()
{
	for(i=1;i<=n;i++)
	printf("%d ",save[i]);
	prinft("\n");
}
int main()
{
	scanf("%d",&n);
	dfs(1);
} 
