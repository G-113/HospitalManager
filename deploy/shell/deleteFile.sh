#!/bin/bash
cd `dirname $0`
APP_HOME=`pwd`
#备份方法
function deleteFile(){
  echo "删除文件： $1"
  sourceDir=$1
  backupDir=${APP_HOME}"/backup/"
  echo "备份跟路径： $backupDir"
  if [[ $sourceDir == $backupDir* ]]
  then
    rm -rf $sourceDir
    echo "删除成功"
  fi
}
deleteFile $1
