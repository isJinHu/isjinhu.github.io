---
title: 'LeetCode刷题笔记: 回溯&贪心&动态规划'
mathjax: true
date: 2024-05-14 14:09:51
categories:
tags:
- LeetCode
- 算法
---
**回溯**就是暴力穷举，是一种搜索方式，其核心思想是从一个初始状态出发，深度优先搜索遍历所有可能的解决方案（解空间），如果确定某种方案不可行就回溯到上一步重新搜索。一般用来解决组合问题（无序）、子集问题（无序）、排列问题（有序）、字符串切割问题、棋盘问题等。

**贪心**算法的思想是在每个决策阶段，选择局部最优解，以此获取全局最优解。

**动态规划**

<!-- more -->

# 回溯

**回溯**就是暴力穷举，其核心思想是从一个初始状态出发，深度优先搜索遍历所有可能的解决方案（解空间），当遇到正解就记录，直到找到解或者尝试所有可能后终止。

可以解决：

- 组合问题：n个数取满足规则的k个数
- 子集问题：n个数有多少符合条件的子集
- 排列问题：n个数按一定规则的全排列有几种方式
- 字符串分割问题：字符串按一定规则有几种切割方式
- 棋盘问题：N皇后、数独等

一般需要考虑3个问题：

- 路径：已经做出的选择
- 选择列表：可以做的选择
- 结束条件：无法再做选择的条件

```python
result = []
def backtrack(path, choices):
    if 满足结束条件:
        result.add(path)
        return
    for choice in choices:
        记录选择
        backtrack(path, choices)
        撤销选择
```

> [回溯算法解题套路框架 | labuladong 的算法笔记](https://labuladong.online/algo/essential-technique/backtrack-framework/)
>
> [代码随想录](https://programmercarl.com/%E5%9B%9E%E6%BA%AF%E7%AE%97%E6%B3%95%E7%90%86%E8%AE%BA%E5%9F%BA%E7%A1%80.html)

## 组合问题

### 77. 组合 - 中等

[77. 组合 - 力扣（LeetCode）](https://leetcode.cn/problems/combinations/)

思路：

## 46. 全排列 - 中等

[46. 全排列](https://leetcode.cn/problems/permutations/?envType=study-plan-v2&envId=top-100-liked)

思路：这题是回溯的经典应用。按我们自己穷举全排列的思路，首先选择第一个的数字，下一个的数字在剩下的数字列表中选择，这样直到所有的数字都选完。所以我们需要记录之前已经选过的数字，从没选过的数字中进行当前阶段的选择。

具体来说，我们可以从第0个位置开始，递归选择每个没被选过的数字，选择完所有元素就回溯撤销选择。

```java
class Solution {
    List<List<Integer>> res;
    List<Integer> path;
    int[] nums;

    public List<List<Integer>> permute(int[] nums) {
        this.res=new ArrayList<>();
        this.path=new ArrayList<>(nums.length);
        this.nums=nums;
        dfs(0, new boolean[nums.length]);
        return res;
    }

    private void dfs(int i, boolean[] used){
        if(nums.length==i){
            res.add(new ArrayList<>(path));
            return;
        }
        for(int j=0;j<nums.length;j++){
            if(!used[j]){
                path.add(nums[j]); // 选择
                used[j]=true;
                dfs(i+1, used); // 递归
                path.remove(i); // 撤销选择
                used[j]=false;
            }
        }
    }
}
```

## 78. 子集 - 中等

[78. 子集](https://leetcode.cn/problems/subsets/description/?envType=study-plan-v2&envId=top-100-liked)

思路：对于每个数字我们可以选或者不选，因此第i层就是对会有对第i个数字选或者不选两个选项。

```java
class Solution {
    List<List<Integer>> res;
    List<Integer> path;
    int[] nums;
    public List<List<Integer>> subsets(int[] nums) {
        this.res=new ArrayList<>();
        this.path=new ArrayList<>();
        this.nums=nums;
        dfs(0);
        return res;
    }
    private void dfs(int i){
        if(i==nums.length){
            res.add(new ArrayList<>(path));
            return;
        }
        // 选这个数字
        path.add(nums[i]);
        dfs(i+1);
		// 不选这个数字
        path.remove(path.size()-1); 
        dfs(i+1);
        // 撤销选择：需要注意这里的撤销选择只的是对这个数字的选择行为本身（回到的是选择上一个数字的状态），而不是选这个数字
    }
}
```

## 39. 组合总和 - 中等

[39. 组合总和](https://leetcode.cn/problems/combination-sum/?envType=study-plan-v2&envId=top-100-liked)

思路：对于每个节点，我们都可以

# 贪心

## [45. 跳跃游戏 II - 力扣（LeetCode）](https://leetcode.cn/problems/jump-game-ii/description/?envType=study-plan-v2&envId=top-interview-150)


