#!/bin/sh


DIR="$( cd "$( dirname "$0" )" && pwd )"

cd $DIR

if [ "$1" = "" ] ; then
    echo ERROR: start\|stop param missing.
elif [ "$1" = "start" ] ; then
    # 准备数据文件夹
    mkdir -p data/fdfs
    if [ ! -d "$DIR/data/solr-home" ] ; then
        echo "Copy solr-home to ./data/ ..."
        cp -r solr/solr-home data/
    fi
    
    # 更新fastfs的IP, 此处也可直接填写虚拟机IP
    IP=`ifconfig enp0s8 | grep inet | awk '{print $2}'| awk -F: '{print $2}'`
    
    sed -i "s|IP=.*$|IP=${IP}|g" fastdfs/docker-compose.yaml
    
    echo BATCH START: activemq, fastdfs,redis-single, solr, zookeeper
    
    cd activemq
    docker-compose up -d
    cd ..

    cd fastdfs
    docker-compose up -d
    cd ..

    cd redis-single
    docker-compose up -d
    cd ..

    cd solr
    docker-compose up -d
    cd ..

    cd zookeeper
    docker-compose up -d
    cd ..
elif [ "$1" = "stop" ]; then
    cd activemq
    docker-compose stop
    cd ..

    cd fastdfs
    docker-compose stop
    cd ..

    cd redis
    docker-compose stop
    cd ..

    cd solr
    docker-compose stop
    cd ..

    cd zookeeper
    docker-compose stop
    cd ..
fi



