---
title: LeetCode刷题笔记：数组&双指针
mathjax: true
date: 2024-05-28 20:43:21
categories:
tags:
- LeetCode
- 算法
---


<!-- more -->

# 双指针

双指针算法是一类用2个指针遍历数组或链表的算法，通常用来解决在数据中进行搜索、排序、匹配的问题。

## 同向双指针

同向双指针也可叫快慢双指针，一般慢指针每次移动一步，快指针则移动两步或更多步。

一般用来解决链表问题。

用在数组中，可以解决有序数组要根据一定条件原地创建新数组这样一类问题。**具体来说，快指针指向旧数组当前遍历位置，慢指针指向新数组长度（下一个元素要放置的位置），根据新旧数组判断快指针指向的元素是否可以加入新数组**，如[88. 合并两个有序数组](https://leetcode.cn/problems/merge-sorted-array/?envType=study-plan-v2&envId=top-interview-150)、[27. 移除元素](https://leetcode.cn/problems/remove-element/description/?envType=study-plan-v2&envId=top-interview-150)、[26. 删除有序数组中的重复项](https://leetcode.cn/problems/remove-duplicates-from-sorted-array/description/?envType=study-plan-v2&envId=top-interview-150)、[80. 删除有序数组中的重复项 II ](https://leetcode.cn/problems/remove-duplicates-from-sorted-array-ii/description/?envType=study-plan-v2&envId=top-interview-150)。

### 88. 合并两个有序数组

[88. 合并两个有序数组](https://leetcode.cn/problems/merge-sorted-array/?envType=study-plan-v2&envId=top-interview-150)

> 输入：nums1 = [1,2,3,0,0,0], m = 3, nums2 = [2,5,6], n = 3
> 输出：[1,2,2,3,5,6]
> 解释：需要合并 [1,2,3] 和 [2,5,6] 。
> 合并结果是 [1,2,2,3,5,6] ，其中斜体加粗标注的为 nums1 中的元素。

从两个数组末尾遍历，慢指针指向下一个元素将要放置的位置，2个快指针分别指向2个数组当前正在对比的元素，哪个数字更大就放置在慢指针指向位置，然后再移动指针。

```java
class Solution {
    public void merge(int[] nums1, int m, int[] nums2, int n) {
        // 同向双指针
        int slow=m+n-1;
        int fast1=m-1, fast2=n-1;
        while(fast1>=0&&fast2>=0){
            if(nums1[fast1]>nums2[fast2]){
                nums1[slow--]=nums1[fast1--];
            }else{
                nums1[slow--]=nums2[fast2--];
            }
        }
        while(fast2>=0){
            nums1[slow--]=nums2[fast2--];
        }
    }
}
```

### 27. 移除元素

[27. 移除元素](https://leetcode.cn/problems/remove-element/description/?envType=study-plan-v2&envId=top-interview-150)

> 输入：nums = [3,2,2,3], val = 3
> 输出：2, nums = [2,2,_,_]
> 解释：你的函数函数应该返回 k = 2, 并且 nums 中的前两个元素均为 2。
> 你在返回的 k 个元素之外留下了什么并不重要（因此它们并不计入评测）

慢指针指向下一个元素将要放置的位置，快指针指向当前遍历位置，如果这个数是要移除的元素，快指针后移，否则将其复制到慢指针指向位置再后移。

```java
class Solution {
    public int removeElement(int[] nums, int val) {
        // 同向双指针
        int slow=0, fast=0;
        while(fast<nums.length){
            if(nums[fast]!=val){
                nums[slow++]=nums[fast];
            }
            fast++;
        }
        return slow;
    }
}
```

### 26. 删除有序数组中的重复项

[26. 删除有序数组中的重复项](https://leetcode.cn/problems/remove-duplicates-from-sorted-array/description/?envType=study-plan-v2&envId=top-interview-150)

> 输入：nums = [1,1,2]
> 输出：2, nums = [1,2,_]
> 解释：函数应该返回新的长度 2 ，并且原数组 nums 的前两个元素被修改为 1, 2 。不需要考虑数组中超出新长度后面的元素。

慢指针指向下一个元素将要放置的位置（相当于新数组长度位置），快指针指向当前遍历位置。

如果快指针指向的元素已经在新数组中slow-1位置出现，那么就重复，快指针直接后移，否则复制到慢指针位置再后移。

```java
class Solution {
    public int removeDuplicates(int[] nums) {
        // 同向双指针
        if(nums.length==1) return 1;
        int slow=1, fast=1;
        while(fast<nums.length){
            if(nums[fast]==nums[slow-1]){
                fast++;
            }else{
                nums[slow++]=nums[fast++];
            }
        }
        return slow;
    }
}
```

### 80. 删除有序数组中的重复项 II 

[80. 删除有序数组中的重复项 II](https://leetcode.cn/problems/remove-duplicates-from-sorted-array-ii/description/?envType=study-plan-v2&envId=top-interview-150)

> 输入：nums = [1,1,1,2,2,3]
> 输出：5, nums = [1,1,2,2,3]
> 解释：函数应返回新长度 length = 5, 并且原数组的前五个元素被修改为 1, 1, 2, 2, 3。 不需要考虑数组中超出新长度后面的元素

慢指针指向下一个元素将要放置的位置（相当于新数组长度位置），快指针指向当前遍历位置。

如果当前元素与新数组的倒数第二个数一样，说明新数组已出现2次该数，该数不需要加入新数组，快指针直接后移，否则复制后再后移。

```java
class Solution {
    public int removeDuplicates(int[] nums) {
        if(nums.length<3) return nums.length;
        int slow=2, fast=2;
        while(fast<nums.length){
            if(nums[slow-2]!=nums[fast]){
                nums[slow++]=nums[fast++];
            }else{
                fast++;
            }
        }
        return slow;
    }
}
```

# 数组

## 169. 多数元素-摩尔投票

[169. 多数元素 - 力扣（LeetCode）](https://leetcode.cn/problems/majority-element/?envType=study-plan-v2&envId=top-interview-150)

寻找长度为n的数组中出现次数大于 `⌊ n/2 ⌋` 的多数元素。

> 输入：nums = [3,2,3]
> 输出：3

**摩尔投票**

1. 记多数元素的票为1，其他为-1，那么所有数字的票数和一定>0
2. 若前a个数字票数和=0，那么剩余的n-a个数字的票数和一定>0，多数元素依旧不变。

因此，票数和=0时，可以缩小剩余数组区间。假设首个元素n为多数元素x，那么当n=x时，抵消的元素中一半是多数元素x；当n!=x时，抵消的多数元素可能是0-一半。因此最后一轮假设的必定是多数元素。

> 多数元素为t个，t>n/2，2(n-t)<n，因此抵消到最后剩余的必定是多数元素为首的数组。

```java
class Solution {
    public int majorityElement(int[] nums) {
        int x=0, votes=0;
        for(int n:nums){
            if(votes==0) x=n;
            votes += n == x ? 1 : -1;
        }
        return x;
    }
}
```

## 189. 轮转数组 #todo 旋转平移类

[189. 轮转数组 - 力扣（LeetCode）](https://leetcode.cn/problems/rotate-array/description/?envType=study-plan-v2&envId=top-interview-150)

首先反转整个数组，然后反转前k个，反转后n-k个，就是轮转后的数组。

**注意**：k=k%n。

```java
class Solution {
    public void rotate(int[] nums, int k) {
        int n=nums.length;
        k=k%n;
        if(k==0) return;
        reverse(nums, 0, nums.length-1);
        reverse(nums, 0, k-1);
        reverse(nums, k, nums.length-1);
    }

    private void reverse(int[] nums, int start, int end){
        while(start<end){
            int tmp=nums[start];
            nums[start++]=nums[end];
            nums[end--]=tmp;
        }
    }
}
```

# 121. 买卖股票的最佳时机

[121. 买卖股票的最佳时机 - 力扣（LeetCode）](https://leetcode.cn/problems/best-time-to-buy-and-sell-stock/description/?envType=study-plan-v2&envId=top-interview-150)

只能在某天买入，未来某天卖出。


> 输入：[7,1,5,3,6,4]
> 输出：5
> 解释：在第 2 天（股票价格 = 1）的时候买入，在第 5 天（股票价格 = 6）的时候卖出，最大利润 = 6-1 = 5 。
>      注意利润不能是 7-1 = 6, 因为卖出价格需要大于买入价格；同时，你不能在买入前卖出股票。

**思路**：只要知道这天之前最低是多少，就是当日最大利润，因此遍历时记录min以及当前利润，更新最大利润即可。

```java
class Solution {
    public int maxProfit(int[] prices) {
        int minPrice=prices[0];
        int res=0;
        for(int i=1;i<prices.length;i++){
            res=Math.max(res, prices[i]-minPrice);
            minPrice=Math.min(minPrice, prices[i]);
        }
        return res;
    }
}
```

## [122. 买卖股票的最佳时机 II - 力扣（LeetCode）](https://leetcode.cn/problems/best-time-to-buy-and-sell-stock-ii/?envType=study-plan-v2&envId=top-interview-150)

在每一天，你可以决定是否购买和/或出售股票。你在任何时候 **最多** 只能持有 **一股** 股票。你也可以先购买，然后在 **同一天** 出售。

> 输入：prices = [7,1,5,3,6,4]
> 输出：7
> 解释：在第 2 天（股票价格 = 1）的时候买入，在第 3 天（股票价格 = 5）的时候卖出, 这笔交易所能获得利润 = 5 - 1 = 4 。
>      随后，在第 4 天（股票价格 = 3）的时候买入，在第 5 天（股票价格 = 6）的时候卖出, 这笔交易所能获得利润 = 6 - 3 = 3 。
>      总利润为 4 + 3 = 7 。

思路：只要比前一天高，就买入，第二天就卖出。

```java
class Solution {
    public int maxProfit(int[] prices) {
        int res=0;
        for(int i=1;i<prices.length;i++){
            if(prices[i]>prices[i-1]){
                res+=prices[i]-prices[i-1];
            }
        }
        return res;
    }
}
```

## [55. 跳跃游戏 - 力扣（LeetCode）](https://leetcode.cn/problems/jump-game/?envType=study-plan-v2&envId=top-interview-150)- 动态规划

给你一个非负整数数组 `nums` ，你最初位于数组的 **第一个下标** 。数组中的每个元素代表你在该位置可以跳跃的最大长度。

判断你是否能够到达最后一个下标，如果可以，返回 `true` ；否则，返回 `false` 。

> 输入：nums = [2,3,1,1,4]
> 输出：true
> 解释：可以先跳 1 步，从下标 0 到达下标 1, 然后再从下标 1 跳 3 步到达最后一个下标。

思路：对于每个位置
