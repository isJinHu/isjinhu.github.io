---
title: LeetCode刷题笔记:图论相关
mathjax: true
date: 2024-09-29 11:10:25
categories:
tags:
- LeetCode
- 算法
---

Floyd算法可以求任意两点之间的最短距离（多源最短路径），核心思想是将每个点作为中间点去更新最短路径。

Dijkstra算法可以求一个点到其他点之间的最短距离（单源最短路径）。

<!-- more -->

# Floyd算法

基于动态规划思想，一共n个点的图，a到b的最短路径，可以基于n-1个点的图计算。记f\[k]\[i]\[j]为从i到j的最短路径，且中间节点编号都<=k
$$
f[k][i][j]=min(f[k-1][i][j], f[k-1][i][k]+f[k-1][k][j]) // 比较是否经过k点时的路径长度
$$
核心代码：

```java
for(int k=0;k<n;k++){
    for(int i=0;i<n;i++){
        for(int j=0;j<n;j++){
            // 可以经过中间点k时，最短路径是否可以更新
            f[i][j]=Math.min(f[i][j], f[i][k]+f[k][j]);
        }
    }
}
```

## [1334. 阈值距离内邻居最少的城市 - 力扣（LeetCode）](https://leetcode.cn/problems/find-the-city-with-the-smallest-number-of-neighbors-at-a-threshold-distance/description/)-中等

```java
class Solution {
    public int findTheCity(int n, int[][] edges, int distanceThreshold) {
        int[][] floyd=new int[n][n];
        for(int i=0;i<n;i++){
            Arrays.fill(floyd[i], -1); 
            floyd[i][i]=0;
        }
        for(int[] e:edges){
            int x=e[0], y=e[1], weight=e[2];
            floyd[x][y]=floyd[y][x]=weight;
        }

        for(int k=0;k<n;k++){
            for(int i=0;i<n;i++){
                for(int j=0;j<n;j++){
                    if(floyd[i][k]>=0&&floyd[k][j]>=0){
                        // 这里一定要记得判断
                        if(floyd[i][j]==-1){
                            floyd[i][j]=floyd[i][k]+floyd[k][j];
                        }else{
                            floyd[i][j]=Math.min(floyd[i][j], floyd[i][k]+floyd[k][j]);
                        }
                        
                    }
                }
            }
        }

        int res=0, minCnt=n+1;
        for(int i=0;i<n;i++){
            int cnt=0;
            for(int j=0;j<n;j++){
                if(floyd[i][j]>=0&&floyd[i][j]<=distanceThreshold){
                    cnt++;
                }
            }
            if(cnt<=minCnt){
                minCnt=cnt;
                res=i;
            }
        }
        return res;
    }
}
```

一般我们会将无法到达设为INF，但是需要注意JAVA中INF+INF会溢出，所以可以设置为Integer.MAX_VALUE/2避免溢出，减少检查，参见：[灵茶山艾府](https://leetcode.cn/problems/find-the-city-with-the-smallest-number-of-neighbors-at-a-threshold-distance/solutions/2525946/dai-ni-fa-ming-floyd-suan-fa-cong-ji-yi-m8s51)。

## 其他题目

[2642. 设计可以求最短路径的图类 - 力扣（LeetCode）](https://leetcode.cn/problems/design-graph-with-shortest-path-calculator/description/)

- 初始化时时间复杂度为$O(n^3+m)$
- 增加边时间复杂度为$O(n^2)$：只需要更新经过这个点的所有情况
- 获取最短路径：$O(1)$，$floyd[i][j]$
- 空间复杂度：$O(n^2)$

[2976. 转换字符串的最小成本 I - 力扣（LeetCode）](https://leetcode.cn/problems/minimum-cost-to-convert-string-i/description/)

- 计算$alpha[26][26]$的最短路径，然后遍历字符串计算更新代价即可。

[2959. 关闭分部的可行集合数目 - 力扣（LeetCode）](https://leetcode.cn/problems/number-of-possible-sets-of-closing-branches/description/)

- 循环将
