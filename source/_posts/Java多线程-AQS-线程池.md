---
title: Java多线程:AQS&线程池
mathjax: true
date: 2024-09-29 21:46:04
categories:
tags:
---
<!-- more -->

ReetrantLock实现了Lock接口

- lock() 加锁
- lockInterruptibly() 响应中断的加锁
- tryLock() 尝试获取锁，非阻塞的获取锁
- unlock() 解锁

**lock**：snyc.lock

**sync**是Sync抽象内部类，是AQS的子类，又有NonFairSync和FairSync两个子类，分别是非公平锁和公平锁，ReentrantLock默认是非公平锁。这些子类基于AQS的模板方法实现了具体的加锁和解锁操作。

**AQS**：AbstractQueuedSynchronizer

**模板方法设计模式**：定义一个操作中的算法的框架，而将一些步骤延迟到子类中。使得子类可以不改变一个算法的结构即可重定义该算法的某些特定步骤。

## AQS

- `volatile int state`：代表同步状态，不同子类实现不同的含义，如ReentrantLock中表示重入次数，Semaphore中表示可用许可数。
  - `final int getState()`：获取同步状态
  - `final void setState(int newState)`：设置同步状态
  - `final boolean compareAndSetState(int expect, int update)`：CAS设置同步状态
    - CAS: Compare And Swap，是一种无锁算法，通过比较内存中的值和期望值，如果相等则更新内存中的值，否则不更新。包括三个操作数：内存值V、旧的预期值A、要修改的新值B。
- `Node`：双向链表，用于保存等待线程，每个Node包含一个Thread引用，一个waitStatus状态，一个prev前驱节点，一个next后继节点。
  - 一个线程是否可以获取锁，取决于state，获取不到则进入等待队列，等待队列是一个双向链表，每个节点代表一个等待线程。

