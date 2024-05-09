#!/bin/bash 
 
cd `dirname $0` 
APP_HOME=`pwd` 
echo "服务部署目录:"$APP_HOME 
# 获取服务
PROJECTNAME=$1
echo $PROJECTNAME

SERVER_FILE="" 
 
# 启动服务
if [ ! -n "$PROJECTNAME" ]; then
PROJECTNAME=$(cat $APP_HOME/jarbal)
echo $PROJECTNAME
fi
 
for i in $PROJECTNAME ; do
  # java 参数
  APP_SERVER_PATH=$APP_HOME/java-opts/sddm-app-server
  JAVA_OPTS=""
  if [ -f "$APP_SERVER_PATH" ]; then
   JAVA_OPTS=$(cat $APP_SERVER_PATH)
  fi
  SERVER_NAME=$i 
  JARPID=$(ps xua | grep ${i}.jar | grep -v grep | awk '{print $2}') 
  if [ $JARPID ] ;then 
    kill -9 $JARPID 
    echo " $SERVER_NAME had beed killed !" 
  else 
    echo "$SERVER_NAME is not running." 
  fi 
  if [ -f "$APP_HOME/java-opts/$SERVER_NAME" ];then 
    JAVA_OPTS=$(cat $APP_HOME/java-opts/$SERVER_NAME)
  fi 
  echo "java 环境变量:"$JAVA_OPTS 
  if [ -f "$APP_HOME/$SERVER_NAME.jar" ];then 
    echo "server file is jar" 
  elif [ -f "$APP_HOME/$SERVER_NAME.war" ];then 
    echo "server file is war" 
  else 
    echo "server file is not exist." 
    continue 
  fi 
  SERVER_FILE=`ls $APP_HOME/$SERVER_NAME.jar || ls $APP_HOME/$SERVER_NAME.war ` 
 
  COMMAND="$JAVA_OPTS  -jar $SERVER_FILE " 
  rm -rf $APP_HOME/$SERVER_NAME.log 
  echo "nohup java $COMMAND >> $APP_HOME/$SERVER_NAME.log 2>&1 &" 
  nohup java $COMMAND >> $APP_HOME/$SERVER_NAME.log 2>&1 & 
 
  if [[ $SERVER_NAME == "sddm-register" || $SERVER_NAME == "sddm-config" ]] ;then 
    echo "sleep 20" 
    sleep 20 
  else 
    echo "sleep 5" 
    sleep 5 
  fi 
 
  ps xua | grep $SERVER_FILE 
  result=$? 
  if [[ $result == 0 ]];then 
     echo "${i} 发布成功!" 
  else 
     echo "${i} 发布失败!" 
  fi 
done 
