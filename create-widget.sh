#!/bin/sh -e

# APP PARAMS
APP_NAME=$1
PATH_APP=$2
COMPLETE_PATH=$2/$1
DEVICE=$3
[ "$DEVICE" = "" ] && DEVICE=fr920xt
MIN_SDK=$4
[ "$MIN_SDK" = "" ] && MIN_SDK=1.2.1
APP_PREFIXE=$(echo $APP_NAME | tr '[:upper:]' '[:lower:]' | tr -d '-')
APP_ENTRY="${APP_PREFIXE}App"
APP_DELEGATE="${APP_PREFIXE}Delegate"
APP_VIEW="${APP_PREFIXE}View"

# PRIVATE KEY
DEVELOPER_KEY=$4
[ "$DEVELOPER_KEY" = "" ] && DEVELOPER_KEY=/Users/alick/developer_key.der
#[ "$DEVELOPER_KEY" = "" ] && DEVELOPER_KEY=/Path/to/key.der

# WIDGET TEMPLATE
cp -r $CONNECTIQ_HOME/bin/templates/widget/simple/ $PATH_APP/$APP_NAME

# APP RESOURCE
RESOURCE_PATH=$(find $COMPLETE_PATH -path "$COMPLETE_PATH/resources*.xml" | xargs | tr ' ' ':')

# APP SOURCES
mv $COMPLETE_PATH/source/App.mc $COMPLETE_PATH/source/${APP_PREFIXE}App.mc
mv $COMPLETE_PATH/source/View.mc $COMPLETE_PATH/source/${APP_PREFIXE}View.mc

#UUID=$(cat /proc/sys/kernel/random/uuid | tr '[:upper:]' '[:lower:]' | tr -d '-')
UUID=$(uuidgen | tr '[:upper:]' '[:lower:]' | tr -d '-')

# UPDATE manifest.xml
xml ed --inplace -u "/iq:manifest/iq:application/@id" -v ${UUID} ${COMPLETE_PATH}/manifest.xml 
xml ed --inplace -u "/iq:manifest/iq:application/@type" -v 'widget' ${COMPLETE_PATH}/manifest.xml
xml ed --inplace -u "/iq:manifest/iq:application/@name" -v '@Strings.AppName' ${COMPLETE_PATH}/manifest.xml
xml ed --inplace -u "/iq:manifest/iq:application/@launcherIcon" -v '@Drawables.LauncherIcon' ${COMPLETE_PATH}/manifest.xml
xml ed --inplace -u "/iq:manifest/iq:application/@entry" -v ${APP_ENTRY} ${COMPLETE_PATH}/manifest.xml
xml ed --inplace -u "/iq:manifest/iq:application/@minSdkVersion" -v ${MIN_SDK} ${COMPLETE_PATH}/manifest.xml
#xml ed --inplace -s "/iq:manifest/iq:application/iq:products" -t elem -n "iq:product" -v "" ${COMPLETE_PATH}/manifest.xml
#xml ed --inplace -s "/iq:manifest/iq:application/iq:products/iq:product" -t attr -n "iq" -v ${DEVICE} ${COMPLETE_PATH}/manifest.xml

# UPDATE source files
sed -i -e "s!\${appClassName}!$APP_ENTRY!g" ${COMPLETE_PATH}/source/${APP_ENTRY}.mc
sed -i -e "s!\${viewClassName}!$APP_VIEW!g" ${COMPLETE_PATH}/source/${APP_ENTRY}.mc
sed -i -e "s!\${viewClassName}!$APP_VIEW!g" ${COMPLETE_PATH}/source/${APP_VIEW}.mc

# UPDATE resources
sed -i -e "s!\${appName}!$APP_NAME!g" ${COMPLETE_PATH}/resources/strings/strings.xml

# ADD BUILD/RUN
SOURCE="${BASH_SOURCE[0]}"
RDIR="$( dirname "$SOURCE" )"
cp $RDIR/build.sh ${COMPLETE_PATH}
cp $RDIR/run.sh ${COMPLETE_PATH}

# UPDATE BUILD/RUN
sed -i -e "s!\${AppName}!$APP_NAME!g" ${COMPLETE_PATH}/build.sh
sed -i -e "s!\${AppName}!$APP_NAME!g" ${COMPLETE_PATH}/run.sh

# CLEAN
rm -f ${COMPLETE_PATH}/*.sh-e
rm -f ${COMPLETE_PATH}/resources/strings/*.xml-e
rm -f ${COMPLETE_PATH}/source/*.mc-e

#EXEC="monkeyc -o ${COMPLETE_PATH}/bin/${APP_NAME}.prg -d ${DEVICE} -m ${COMPLETE_PATH}/manifest.xml -z ${RESOURCE_PATH} ${COMPLETE_PATH}/source/*.mc -w -y ${DEVELOPER_KEY}"
#echo $EXEC

monkeyc -o ${COMPLETE_PATH}/bin/${APP_NAME}.prg -d ${DEVICE} -m ${COMPLETE_PATH}/manifest.xml -z ${RESOURCE_PATH} ${COMPLETE_PATH}/source/*.mc -w -y ${DEVELOPER_KEY}
