---
title: LeetCode刷题笔记：滑动窗口
mathjax: true
date: 2024-09-03 10:04:34
categories:
tags:
- LeetCode
- 算法
---

**滑动窗口算法**的核心思想是通过两个指针来定义一个窗口，通过动态调整窗口大小和位置来求解问题。

通常用于解决子数组、子串、子序列相关问题，比如：最大最小子数组（最大子数组和）、（包含所有字符的/无重复字符的）子字符串、定长子数组的最大/小值、滑动窗口平均值。

<!-- more -->

# 滑动窗口

## 子串

### 3. 无重复字符的最长子串 - 中等

[3. 无重复字符的最长子串 - 力扣（LeetCode）](https://leetcode.cn/problems/longest-substring-without-repeating-characters/?envType=study-plan-v2&envId=top-100-liked)

给定一个字符串 `s` ，请你找出其中不含有重复字符的最长子串的长度。

```java
class Solution {
    public int lengthOfLongestSubstring(String s) {
        int res=0;
        int start=0, end=0; // 滑动窗口指针
        Map<Character, Integer> lastOccuredMap=new HashMap<>(); // 记录字符出现位置+1,遇到重复窗口起点应移动到此处
        while(end<s.length()){
            char c=s.charAt(end++); // 窗口扩大
            if(lastOccuredMap.containsKey(c)){ // 是否需要缩小
                start=Math.max(start, lastOccuredMap.get(c));
            }
            res=Math.max(res, end-start);
            lastOccuredMap.put(c, end);
        }
        return res;
    }
}
```

### 438. 找到字符串中所有字母异位词 -中等 （类似最小覆盖子串）

[438. 找到字符串中所有字母异位词 - 力扣（LeetCode）](https://leetcode.cn/problems/find-all-anagrams-in-a-string/?envType=study-plan-v2&envId=top-100-liked)

给定两个字符串 `s` 和 `p`，找到 `s` 中所有 `p` 的 **异位词** 的子串，返回这些子串的起始索引。不考虑答案输出的顺序。

```java
class Solution {
    public List<Integer> findAnagrams(String s, String p) {
        List<Integer> res=new ArrayList<>();
        if(s.length()<p.length()) return res;
        Map<Character, Integer> targetMap=new HashMap<>(); // 目标窗口
        Map<Character, Integer> windowMap=new HashMap<>(); // 滑动窗口记录
        for(char c:p.toCharArray()){
            targetMap.put(c, targetMap.getOrDefault(c,0)+1);
        }
        int start=0, end=0; // 滑动窗口指针
        int count=0;
        while(end<s.length()){
            char cur=s.charAt(end++);
            if(targetMap.containsKey(cur)){
                windowMap.put(cur, windowMap.getOrDefault(cur, 0)+1);
                if(windowMap.get(cur).equals(targetMap.get(cur))) count++; // 注意：这里是Integer，一定得用equals，而不是==
            }
            while(targetMap.size()==count){
                if(end-start==p.length()){
                    res.add(start);
                }
                char expired=s.charAt(start++);
                if(targetMap.containsKey(expired)){
                    if(targetMap.get(expired).equals(windowMap.get(expired))) count--;
                    windowMap.put(expired, windowMap.get(expired)-1);
                }
            }
        }
        return res;
    }
}
```

### 567. 字符串的排列 - 中等

[567. 字符串的排列 - 力扣（LeetCode）](https://leetcode.cn/problems/permutation-in-string/description/)

```java
class Solution {
    public boolean checkInclusion(String s1, String s2) {
        if(s1.length()>s2.length()) return false;
        Map<Character, Integer> targetMap=new HashMap<>(); // 目标窗口
        Map<Character, Integer> windowMap=new HashMap<>(); // 滑动窗口记录
        for(char c:s1.toCharArray()){
            targetMap.put(c, targetMap.getOrDefault(c,0)+1);
        }
        int start=0, end=0; // 滑动窗口指针
        int count=0;
        while(end<s2.length()){
            char cur=s2.charAt(end++);
            if(targetMap.containsKey(cur)){
                windowMap.put(cur, windowMap.getOrDefault(cur, 0)+1);
                if(windowMap.get(cur).equals(targetMap.get(cur))) count++; // 注意：这里是Integer，一定得用equals，而不是==
                while(count==targetMap.size()){
                    if(end-start==s1.length()){return true;}
                    char expired=s2.charAt(start++);
                    if(windowMap.get(expired).equals(targetMap.get(expired))) count--;
                    windowMap.put(expired, windowMap.get(expired)-1);
                }
            }else{
                windowMap=new HashMap<>();
                count=0;
                start=end;
            }
        }
        return false;
    }
}
```

## 76. 最小覆盖子串 - 困难

[76. 最小覆盖子串 - 力扣（LeetCode）](https://leetcode.cn/problems/minimum-window-substring/)

```java
class Solution {
    public String minWindow(String s, String t) {
        if(s.length()<t.length()) return "";
        Map<Character, Integer> targetMap=new HashMap<>(); // 目标窗口
        Map<Character, Integer> windowMap=new HashMap<>(); // 滑动窗口记录
        for(char c:t.toCharArray()){
            targetMap.put(c, targetMap.getOrDefault(c,0)+1);
        }
        int start=0, end=0; // 滑动窗口指针
        int minLen=s.length()+1, minStart=0, minEnd=0;
        int count=0;
        while(end<s.length()){
            char cur=s.charAt(end++);
            if(targetMap.containsKey(cur)){
                windowMap.put(cur, windowMap.getOrDefault(cur, 0)+1);
                if(windowMap.get(cur).equals(targetMap.get(cur))) count++; // 注意：这里是Integer，一定得用equals，而不是==
            }
            while(targetMap.size()==count){
                if(end-start<minLen){
                    minLen=end-start;
                    minStart=start;
                    minEnd=end;
                }
                char expired=s.charAt(start++);
                if(targetMap.containsKey(expired)){
                    if(targetMap.get(expired).equals(windowMap.get(expired))) count--;
                    windowMap.put(expired, windowMap.get(expired)-1);
                }
            }
        }
        return s.substring(minStart, minEnd);
    }
}
```

