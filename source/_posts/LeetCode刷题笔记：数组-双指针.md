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

