#include<stdio.h>
int map[10][10];
int visit[10][10];
int cnt,n,m;

int main()
{
	scanf("%d%d",&n,&m);
	input();
	scanf("%d%d%d%d",&stx,&sty,&enx,&eny);
	dfs(stx,sty);
}

void dfs(int x, int y)
{
	visit[x][y] = 1;
	if(x==enx && x== eny)
	{
		cnt++;
	}
	else {
		int tarx, tary;
		// condition 1
		tarx = x, tary = y-1;
		if(tary>=1 && visit[tarx][tary]==0 && map[tarx][tary] == 0)
		{
			dfs(tarx,tary);
		}
		// condition 2
		tarx = x+1, tary = y;
		if(tarx<=n && visit[tarx][tary]==0 && map[tarx][tary] == 0)
		{
			dfs(tarx,tary);
		}
		// condition 3
		tarx = x,tary = y+1;
		if(tary<=m && visit[tarx][tary]==0 && map[tarx][tary] == 0)
		{
			dfs(tarx, tary);
		}
		// condition 4
		tarx = x-1, tary = y;
		if(tarx>=1 && visit[tarx][tary]==0 && map[tarx][tary] == 0){
			dfs(tarx, tary);
		}
	}
	visit[x][y] = 0;
	return;
}
