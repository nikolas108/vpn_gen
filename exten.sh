#!/bin/bash
count=$#
peer=$1
g=200
file=/etc/asterisk/extensions.conf
while [ $count -gt 0 ]
  do
	echo "first looP"
	ssh as29 "sed -i \"200iexten => $peer,1,Dial(SIP\/\$\{EXTEN\})\" $file"
	ssh as29 "sed -i \"201iexten => $peer,n,Playback(vm-nobody)\" $file"
	ssh as29 "sed -i \"202iexten => $peer,n,Hangup()\" $file"
	ssh as29 "asterisk -x 'core reload'"
	ssh as22 "sed -i \"10iexten => $peer,1,Dial(SIP\/a2\/\$\{EXTEN\})\" $file"
	ssh as22 "sed -i \"11iexten => $peer,n,Playback(vm-nobody)\" $file"
	ssh as22 "sed -i \"12iexten => $peer,n,Hangup()\" $file"
	ssh as22 "asterisk -x 'core reload'"
	let "count=$count-1"
  done	
