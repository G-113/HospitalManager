#!/bin/bash
# 部署服务器ip
echo "部署服务器:"$SERVER_IP
DEPLOY_PATH=/opt/designer
echo "部署路径:"$DEPLOY_PATH

if [ $PACKAGE == true ]; then
  mkdir -p ${WORKSPACE}/webform-server/target
  rm -rf ${WORKSPACE}/webform-server/target/webform-server.jar
  mv ${WORKSPACE}/sddm-webform-app/sddm-app-webform-server/webform-server/target/webform-server.jar ${WORKSPACE}/webform-server/target/webform-server.jar
  mkdir -p ${WORKSPACE}/sddm-print/target
  rm -rf ${WORKSPACE}/sddm-print/target/sddm-print.jar
  mv ${WORKSPACE}/sddm-webform-app/sddm-app-print/sddm-print/target/sddm-print.jar ${WORKSPACE}/sddm-print/target/sddm-print.jar
  mkdir -p ${WORKSPACE}/sddm-test-manager/target
  rm -rf ${WORKSPACE}/sddm-test-manager/target/sddm-test-manager.jar
  mv ${WORKSPACE}/sddm-webform-app/sddm-app-test-manager/sddm-test-manager/target/sddm-test-manager.jar ${WORKSPACE}/sddm-test-manager/target/sddm-test-manager.jar

fi
#####

PROJECTNAME=$(echo $JARNAME  | sed "s/,/ /g" | sed 's/"/ /g')
echo $PROJECTNAME > ${WORKSPACE}/jarbal
echo "scp ${WORKSPACE}/jarbal root@$SERVER_IP:$DEPLOY_PATH/"
scp ${WORKSPACE}/jarbal root@$SERVER_IP:$DEPLOY_PATH/
echo "scp ${WORKSPACE}/deploy/shell/deploy.sh  root@$SERVER_IP:$DEPLOY_PATH/"
scp ${WORKSPACE}/deploy/shell/deploy.sh  root@$SERVER_IP:$DEPLOY_PATH/
echo "scp ${WORKSPACE}/deploy/shell/java-opts/$DEPLOY_PROJECT/${SERVER_ENV}/sddm-app-server root@$SERVER_IP:$DEPLOY_PATH/java-opts/"
scp ${WORKSPACE}/deploy/shell/java-opts/$DEPLOY_PROJECT/${SERVER_ENV}/sddm-app-server root@$SERVER_IP:$DEPLOY_PATH/java-opts/

for i in $PROJECTNAME ; do
    if [ -f "${WORKSPACE}/deploy/shell/java-opts/${SERVER_ENV}/${i}" ];then
        echo "scp ${WORKSPACE}/deploy/shell/java-opts/${SERVER_ENV}/${i} root@$SERVER_IP:$DEPLOY_PATH/java-opts/"
        scp ${WORKSPACE}/deploy/shell/java-opts/${SERVER_ENV}/${i} root@$SERVER_IP:$DEPLOY_PATH/java-opts/
    fi
    echo "scp ${WORKSPACE}/${i}/target/${i}.jar root@$SERVER_IP:$DEPLOY_PATH/"
    scp ${WORKSPACE}/${i}/target/${i}.jar root@$SERVER_IP:$DEPLOY_PATH/
done
