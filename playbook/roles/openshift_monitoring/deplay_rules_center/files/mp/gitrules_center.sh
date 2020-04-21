#!/bin/sh

searchDir="/home/sysansible/prometheus/acm-ocp-prometheus-rules-center/rules"

cd /home/sysansible/prometheus/acm-ocp-prometheus-rules-center;git pull

mkdir -p /home/sysansible/prometheus/center/rules

## Build rules infra
for dir in "$searchDir"/*
do
  dname=$(basename $dir)
  for file in "$dir"/*
  do
    fname=$(basename $file)
    nname="$dname-$fname"
    cp "$file" "/home/sysansible/prometheus/center/rules/$nname"
  done
done

scp -i /home/sysansible/.ssh/id_rsa  -r /home/sysansible/prometheus/center/rules sysansible@10.12.24.99:/home/sysansible/
rm -rf /home/sysansible/prometheus/center