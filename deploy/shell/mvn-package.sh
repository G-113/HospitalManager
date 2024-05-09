#!/bin/bash
cd ${WORKSPACE}
result=0
if [ $PACKAGE == true ]; then
  if [ $UPDATE_DEPENDENCY == true ]; then
    echo "mvn clean package -P$SERVER_ENV -U -DskipTests"
    echo "start packing"
    mvn clean package -P$SERVER_ENV -U -DskipTests
    result=$?
  else
    echo "mvn clean package -P$SERVER_ENV -DskipTests"
    echo "start packing"
    mvn clean package -P$SERVER_ENV -DskipTests
    result=$?
  fi
fi

if [ $result -ne '0' ] ; then
  echo 'build failed'; exit $result
fi
echo "finish packing"
