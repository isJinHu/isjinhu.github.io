---
title: GitHub Pages & Hexo 搭建博客
date: 2023-08-28 12:49:15
mathjax: true
tags:
- GitHub
- Hexo
---

# GitHub Pages & Hexo 搭建博客

## Hexo 安装与配置

> [Hexo 安装与配置 | Easy Hexo 👨‍💻](https://easyhexo.com/1-Hexo-install-and-config/)

1. 确认本地已经安装 Git 和 Node.js
2. 安装hexo: `npm install -g hexo-cli`
3. 在本地创建一个文件夹，然后往这个文件夹中安装Hexo
4. 配置 Hexo，其配置文件为_config.yml：[配置 Hexo | Easy Hexo 👨‍💻](https://easyhexo.com/1-Hexo-install-and-config/1-3-config-hexo.html#配置-hexo-2)

```
 npm install -g hexo-cli # 安装Hexo
 mkdir mkdir <your_blog_name>  # 建立你的网站根目录，名字可以自己修改
 hexo init <your_blog_name> # 往这个文件夹中安装Hexo
```

## Hexo的keep主题安装与配置

> [Keep 主题使用指南 | Hexo 主题 Keep 官方文档](https://keep-docs.xpoet.cn/) && [XPoet's Blog](https://xpoet.cn/)

Step 1: 安装Keep主题

```
 cd <your_blog_name>
 npm install hexo-theme-keep
```

Step 2: 使用Keep主题：在 Hexo 配置文件`_config.yml` 中将 theme 设置为 keep。

```
 theme: keep
```

Step 3：配置Keep主题：在<your_blog_name>文件夹下创建一个`_config.keep.yml`文件，参照文档进行配置：[base_info | Keep 主题使用指南](https://keep-docs.xpoet.cn/tutorial/configuration-guide/base_info.html)

其他：

- 可能用到的命令：

	```
	 npm install hexo-theme-keep # 安装 keep 主题
	 npm install hexo-filter-mathjax # 安装显示数学公式的插件
	 npm install hexo-generator-searchdb # 安装站内搜索插件
	 hexo new page about # hexo创建页面命令，使用该命令创建about页面。
	```

- [数学公式 | Keep 主题使用指南](https://keep-docs.xpoet.cn/advanced/mathjax.html)：建议开启。

- 配置时的图标文件可以放在`source/images`文件夹中。

## **使用GitHub Pages部署到GitHub**

> [部署 Hexo | Easy Hexo 👨‍💻](https://easyhexo.com/1-Hexo-install-and-config/1-4-deploy-hexo.html#部署到-github)

Step 1: 创建一个仓库：<username>.github.io

Step 2: 在<your_blog_name>（<username>.github.io）安装部署插件

```shell
 npm install hexo-deployer-git --save
 npm install hexo-server --save
```

Step 3: 部署到 GitHub

```shell
 hexo clean && hexo d -g
```

### GitHub保存博客项目的源代码

```shell
# 本地博客项目根目录下运行
git init
git checkout -b hexo # 切换分支
git add .
git commit -m "init"
git remote add origin git@github.com:isJinHu/isjinhu.github.io.git # 添加远程仓库
git remote -v
git push origin hexo:hexo # push到远程仓库的hexo分支
```

## 其他

1. `hexo new <artical_name>`创建一篇新文章

2. Gitalk设置：[comment | Keep 主题使用指南](https://keep-docs.xpoet.cn/tutorial/configuration-guide/comment.html#gitalk)

3. `/scaffolds/post.md`: 修改post模板，可以设置默认打开数学公式渲染等

  ```yaml
  title: {{ title }}
  date: {{ date }}
  mathjax: true
  tags:
  ```