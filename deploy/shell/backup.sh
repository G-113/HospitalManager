#!/bin/bash
#备份方法
function backup(){
  echo "源文件夹： $1"
  echo "备份文件夹：$2"
  sourceDir=$1
  targetDir=$2
  if [[ $sourceDir == *.jar* ]]; then
     cp $1 $2
     if [ $? -eq 0 ]; then
       echo "备份 jar 成功"
     else
       echo "备份 jar 失败"
     fi
  else
    # 判断目标文件是否存在
    if [ ! -d $targetDir ]; then
       mkdir -p $targetDir
    fi
    #遍历源文件夹中的文件
    for fileName in `ls $1`; do
      #copy后缀为jar的文件到备份文件夹并重命名
      cp $1$fileName $targetDir${fileName}
      #判断本分操作是否成功
      if [ $? -eq 0 ];
      then
        echo "备份 $fileName 成功"
      else
        echo "备份 $fileName 失败"
      fi
    done
  fi
}
backup $1 $2
