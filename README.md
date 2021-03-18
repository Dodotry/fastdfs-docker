# fastdfs-docker
happyfish100/fastdfs基于CentOS8 的docker安装，离线版Dockerfile环境。

- 优化记录

基于Centos8镜像，nginx更新到最新版本nginx1.19.8；FastDFS更新到FastDFS v6.07版本，在delron/fastdfs基础上修正TRACKER_SERVER环境变量为IP地址，不带端口。

- 挂载目录

数据目录：/home/fdfs

docker-compose创建如下：

```html
version: "3.7"
services:
    tracker:
        image: 'dodotry/fastdfs:latest'
        restart: always
        container_name: 'tracker'
        hostname: 'tracker'
        privileged: true
        network_mode: "host"
        environment:
            TZ: 'Asia/Shanghai'
        volumes:
            - ./tracker/data:/home/fdfs
            - /etc/localtime:/etc/localtime:ro
        command: tracker
    storage:
        image: 'dodotry/fastdfs:latest'
        restart: always
        container_name: 'storage'
        hostname: 'storage'
        privileged: true
        network_mode: "host"
        environment:
            TZ: 'Asia/Shanghai'
            TRACKER_SERVER: '192.168.0.45'
        volumes:
            - ./storage/data:/home/fdfs
            - /etc/localtime:/etc/localtime:ro
        command: storage
```
