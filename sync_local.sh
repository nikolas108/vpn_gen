#!/bin/bash
SCRIPTS_DIR=`pwd`
cd ..
HOME=`pwd`
VM=as29
SRV=$1

if [ -z $1 ];then
exit 1
fi

if [ "$1" = "a2y" ];then
  rsync -avPu as29/a2y/clients/ vpnt1/v1y2/clients/
  rsync -avPu as29/a2y/ccd/ vpnt1/v1y2/ccd/
  rsync -avPu as29/a2y/clients/ vpnt2/v2y2/clients/
  rsync -avPu as29/a2y/ccd/ vpnt2/v2y2/ccd/
fi


