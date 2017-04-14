#! /bin/zsh
if [ -e /tmp/artech ]; then
	echo '/tmp/artech Exist'
else
	echo '/tmp/artech not Exist，make one'
	mkdir /tmp/artech
fi

if [ ! -e ./Frameworks ]; then
	echo 'Frameworks not Exist.'
	mkdir Frameworks
fi
cd Frameworks
pwd

if [ ! -e /tmp/artech/EZGLib.framework.zip ]; then
	echo '/tmp/artech/EZGLib.framework.zip not exist, Download it.'
	curl http://7fva7j.com1.z0.glb.clouddn.com/EZGLib.framework.zip > /tmp/artech/EZGLib.framework.zip
fi

echo 'unzip EZGLib.framework.zip.'
unzip -o /tmp/artech/EZGLib.framework.zip

if [ ! -e /tmp/artech/opencv2.framework.zip ]; then
	echo '/tmp/artech/opencv2.framework.zip not exist, Download it.'
	curl http://7fva7j.com1.z0.glb.clouddn.com/opencv2.framework.zip > /tmp/artech/opencv2.framework.zip
fi

echo 'unzip opencv2.framework.zip.'
unzip -o /tmp/artech/opencv2.framework.zip


