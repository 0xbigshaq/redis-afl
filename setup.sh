#!/bin/bash
cd /root/redis-dir

# creating a dictionary 
mkdir dict && cd dict
cat ../redis/src/server.c | grep Command, | sed 's/ //g' | grep -oP '{"(.*?)"' | sort | uniq | sed -e s/\"//g -e s/{//g > cmds.txt
cat cmds.txt | while read line; do echo "${line}">${line}.cmd; done
mv cmds.txt ../ 
cd ../


# making the crash results accessible via a shared volume (if we run the container with the -v arg)
mkdir -p /root/host-share/
ln -s /root/host-share/ /root/redis-dir/output


# adjusting network configs
cp ./redis/redis.conf .
sed 's/bind 127.0.0.1 -::1/bind 127.0.0.1/' ./redis/redis.conf | tee ./redis.conf
mv ./redis/redis.conf ./redis/redis-OLD.conf