#!/bin/bash

currdir=`pwd`

echo "dev=hlxd0mw01.unix.marksandspencerdev.com
mmcd=hlxd0mw02.unix.marksandspencerdev.com
cate=hlxc0mw004.unix.marksandspencercate.com
mmcc=hlxc0mw005.unix.marksandspencercate.com
intb1=hlxc0mw001.unix.marksandspencercate.com
intb2=hlxc0mw002.unix.marksandspencercate.com
mmci=hlxc0mw003.unix.marksandspencercate.com
prod1=hlxp0mw001.unix.marksandspencer.com
prod2=hlxp0mw002.unix.marksandspencer.com
mmcp=hlxp0mw003.unix.marksandspencer.com
graylogd=hlxd0m004.unix.marksandspencerdev.com
graylogc=hlxc0m0005.unix.marksandspencercate.com
mqftec=hlxc0fte01.unix.marksandspencercate.com" >login.properties

. $currdir/login.properties

env=$1
user=$2
loginserver="${!env}"

ssh ${user}@${loginserver}
