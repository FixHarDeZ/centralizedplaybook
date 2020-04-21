#!/bin/sh

searchDir="/home/sysansible/prometheus/acm-ocp-prometheus-rules-infra/rules"

cd /home/sysansible/prometheus/acm-ocp-prometheus-rules-infra;git pull

mkdir -p /home/sysansible/prometheus/sys/rules/infra

## Build rules infra
for dir in "$searchDir"/*
do
if [ "$dir" != /home/sysansible/prometheus/acm-ocp-prometheus-rules-infra/rules/ps ]
then
  dname=$(basename $dir)
  for file in "$dir"/*
  do
    fname=$(basename $file)
    nname="$dname-$fname"
    cp "$file" "/home/sysansible/prometheus/sys/rules/infra/$nname"
  done
fi
done

## Build rules infra
#for dir in "$searchDir"/*
#do
#echo $dir
#if [ "$dir" = /home/sysansible/prometheus/acm-ocp-prometheus-rules-infra/rules/ps/nonprod ]
#then
  #dname=$(basename $dir)
  #echo $dname
  #echo $dir
  for file in /home/sysansible/prometheus/acm-ocp-prometheus-rules-infra/rules/ps/nonprod/*
  do
    fname=$(basename $file)
    nname="ps-$fname"
    cp "$file" "/home/sysansible/prometheus/sys/rules/infra/$nname"
  done
#fi
#done

scp -i /home/sysansible/.ssh/id_rsa  -r /home/sysansible/prometheus/sys/rules sysansible@10.14.24.103:/home/sysansible/
scp -i /home/sysansible/.ssh/id_rsa  -r /home/sysansible/prometheus/sys/rules sysansible@10.14.24.108:/home/sysansible/
rm -rf /home/sysansible/prometheus/sys