#!/bin/bash

contaner_name="qqwry"
port=8888

while getopts ":n:p:" opt
do
    case $opt in
        n)
        contaner_name=$OPTARG
        ;;
        p)
        port=$OPTARG
        ;;
    esac
done

export CONTAINER_NAME=${contaner_name}
export PORT=${port}

echo container_name $CONTAINER_NAME
echo port $PORT

projectPath=$(pwd)

cd ../../

export GOPATH=$(pwd)

echo "GOPATH=$GOPATH"

cd ${projectPath}

echo "glide install"

glide install

if [ $? -eq 0 ]; then
  echo "build..."
  CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o qqwry *go
  chmod +x qqwry
else
  echo "glide install fail"
  exit 1
fi

docker-compose up -d --build --remove-orphans

docker-compose restart




