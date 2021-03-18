# centos 8
FROM centos:latest

ENV FASTDFS_BASE_PATH /home/fdfs 

# 添加配置文件
# add profiles
ADD conf/http.conf /etc/fdfs/
ADD conf/mime.types /etc/fdfs/
ADD startdfs.sh /usr/bin/


# 添加源文件
# add source code
ADD source/libfastcommon.tar.gz /usr/local/src/
ADD source/fastdfs.tar.gz /usr/local/src/
ADD source/fastdfs-nginx-module.tar.gz /usr/local/src/
ADD source/nginx-1.19.8.tar.gz /usr/local/src/

RUN export LC_ALL=C
RUN yum update -y
# Run
RUN yum install git gcc gcc-c++ make automake autoconf libtool pcre pcre-devel zlib zlib-devel openssl-devel wget vim -y \
  &&  mkdir /home/fdfs   \
  &&  cd /usr/local/src/  \
  &&  cd libfastcommon/   \
  &&  ./make.sh && ./make.sh install  \
  &&  cd ../  \
  &&  cd fastdfs/   \
  &&  ./make.sh && ./make.sh install  \
  &&  cd ../  \
  &&  cd nginx-1.19.8/  \
  &&  ./configure --add-module=/usr/local/src/fastdfs-nginx-module/src/ --with-http_stub_status_module --with-http_ssl_module --with-file-aio --with-http_realip_module  \
  &&  make && make install  \
  &&  chmod a+x /usr/bin/startdfs.sh \
  &&  rm -rf /usr/local/src/*

ADD conf/client.conf /etc/fdfs/
ADD conf/storage.conf /etc/fdfs/
ADD conf/storage_ids.conf /etc/fdfs/
ADD conf/tracker.conf /etc/fdfs/
ADD conf/mod_fastdfs.conf /etc/fdfs/
ADD conf/nginx.conf /usr/local/nginx/conf/
ADD conf/favicon.ico /usr/local/nginx/html/

# export config
VOLUME ["$FASTDFS_BASE_PATH", "/etc/fdfs"]

EXPOSE 22122 23000 8888 8080
ENTRYPOINT ["/usr/bin/startdfs.sh"]