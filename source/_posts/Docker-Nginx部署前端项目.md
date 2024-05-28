---
title: Docker + Nginx部署前端项目
mathjax: true
date: 2024-05-10 13:48:07
categories:
- Docker
tags:
- Docker
---

**后端部署**可以查看：[GitHub Actions & Docker实现自动化部署 | Jin's Blog (isjinhu.github.io)](https://isjinhu.github.io/2024/05/10/GitHub-Actions-Docker实现自动化部署/)

<!--more-->

# Docker + Nginx部署前端项目

此处省略Docker安装步骤。

```shell
 sudo docker run --rm hello-world # 使用该命令可以测试docker是否安装成功
```

## **Step 1**: 拉取Nginx镜像

```shell
docker pull nginx # 拉取镜像，没有指定版本会默认下载最新 
```

## **Step 2**: 创建挂载目录

```shell
 # 注意当前路径切换
 mkdir -p nginx/html
 mkdir -p nginx/logs
 mkdir -p nginx/conf
 cd nginx
 chomd 777 html logs conf
```

## **Step 3**: 启动一个不挂载的容器

```shell
 docker run -d --name nginx -p 1000:80 nginx
```

- `--name nginx`：指定容器名称
- `-p 1000:80` 映射端口（宿主机:容器）
	- 这里可以自选端口，使用`lsof -i:1000`查看端口是否被占用
- `-d` 守护进程运行

## **Step 4**: 拷贝容器内默认配置

```shell
 docker cp nginx:/etc/nginx/nginx.conf nginx/conf/nginx.conf
 docker cp nginx:/etc/nginx/conf.d nginx/conf/conf.d
 docker cp nginx:/usr/share/nginx/html nginx/
```

## **Step 5**: 停止、删除容器

```shell
 docker stop nginx # 停止容器
 docker rm nginx # 删除容器
 docker ps -a # 查看所有容器
```

## **Step 6**: 部署前端项目

- 将前端项目目录（vue项目build后的dist目录）上传至`nginx/html`目录下，并修改`nginx/conf.d/default.conf`文件。

- 内容可以参考，其中proxy_pass记得修改为对应部署的后端地址，listen为前端的端口。

	```nginx
	server {
	    listen 1001;
	    location / {
	        root /usr/share/nginx/html/hmdp;
	    }
	
	    error_page   500 502 503 504  /50x.html;
	    location = /50x.html {
	        root   /usr/share/nginx/html;
	    }
	    location /api {
	        default_type  application/json;
	        #internal;
	        keepalive_timeout   30s;
	        keepalive_requests  1000;
	        #支持keep-alive
	        proxy_http_version 1.1;
	        rewrite /api(/.*) $1 break;
	        proxy_pass_request_headers on;
	        #more_clear_input_headers Accept-Encoding;
	        proxy_next_upstream error timeout;
	        proxy_pass http://127.0.0.1:8081;
	        # proxy_pass http://backend;
	    }
	}
	
	# upstream backend {
	#     server 127.0.0.1:80 max_fails=5 fail_timeout=10s weight=1;
	#     server 127.0.0.1:8082 max_fails=5 fail_timeout=10s weight=1;
	# }
	```

## **Step 7**: 运行镜像，其中-p指定对应的端口映射。

```shell
docker run \                  
-p 1000:80 \
-p 1001:1001 \
--name nginx \
-v /home/ubuntu/nginx/conf/nginx.conf:/etc/nginx/nginx.conf \
-v /home/ubuntu/nginx/conf/conf.d:/etc/nginx/conf.d \
-v /home/ubuntu/nginx/logs:/var/log/nginx \
-v /home/ubuntu/nginx/html:/usr/share/nginx/html \
-d nginx:latest
```

