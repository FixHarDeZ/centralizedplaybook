#!/bin/sh

searchDirnonprod="/home/sysansible/prometheus/app-nonprod/acm-ocp-prometheus-rules-apps/rules"
searchDirprod="/home/sysansible/prometheus/app-prod/acm-ocp-prometheus-rules-apps/rules"

mkdir /home/sysansible/prometheus/app
mkdir /home/sysansible/prometheus/app/rules
mkdir /home/sysansible/prometheus/infra

cd /home/sysansible/prometheus/app-nonprod/acm-ocp-prometheus-rules-apps;git pull
cd /home/sysansible/prometheus/app-prod/acm-ocp-prometheus-rules-apps;git pull

rm -rf "$searchDirprod/$1"

cp -r "$searchDirnonprod/$1" "$searchDirprod/$1"

cd /home/sysansible/prometheus/app-prod/acm-ocp-prometheus-rules-apps/;git add .;git commit -a -m "$1";git push origin prod

## Build rules app
for dir in "$searchDirprod"/*
do
  dname=$(basename $dir)
  echo "update service-group:" $dname;
  for file in "$dir/app"/*
  do
    if [[ $file =~ ".yml" ]]
    then
      fname=$(basename $file)
      nname="$dname-$fname"
      cp "$file" "/home/sysansible/prometheus/app/rules/$nname"
      echo "update rule:" $nname
    fi
  done
done

## Build rules infra
for dir in "$searchDirprod"/*
do
  dname=$(basename $dir)
  echo "update service-group:" $dname;
  for file in "$dir/infra"/*
  do
    if [[ $file =~ ".yml" ]]
    then
      fname=$(basename $file)
      nname="$dname-$fname"
      cp "$file" "/home/sysansible/prometheus/infra/$nname"
      echo "update rule:" $nname
    fi
  done
done

scp -i /home/sysansible/.ssh/ansible_key.pem  -r /home/sysansible/prometheus/app/rules sysansible@10.12.24.101:/home/sysansible/
scp -i /home/sysansible/.ssh/ansible_key.pem  -r /home/sysansible/prometheus/infra sysansible@10.12.24.103:/home/sysansible/app
scp -i /home/sysansible/.ssh/ansible_key.pem  -r /home/sysansible/prometheus/app/rules sysansible@10.12.24.106:/home/sysansible/
scp -i /home/sysansible/.ssh/ansible_key.pem  -r /home/sysansible/prometheus/infra sysansible@10.12.24.108:/home/sysansible/app
rm -rf /home/sysansible/prometheus/app
rm -rf /home/sysansible/prometheus/infra