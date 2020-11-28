#include<stdio.h>
int map[16][16];
int n,m,stx,sty,enx,eny;
int cnt;
void dfs(int x,int y)
{
	if(map[x][y] == 0 && x>=1 && y>=1 && x<=n && y<=m) // 是否可以访问此处 
	{
		if(x==enx&&y==eny)
		{
			cnt++;
		}
		else {
			map[x][y] = 1;
			dfs(x-1,y);
			dfs(x,y+1);
			dfs(x+1,y);
			dfs(x,y-1);
			map[x][y] = 0;
		}
	}
}

int main()
{
	scanf("%d%d",&n,&m);
	for(i=1;i<=n;i++)
		for(j=1;j<=m;j++)
		scanf("%d",&map[i][j]);
	// input start and end
	scanf("%d%d%d%d",&stx,&sty,&enx,&eny);
	dfs(stx,sty);
	printf("%\n",cnt);
	return 0;
	
}
