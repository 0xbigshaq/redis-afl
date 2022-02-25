#!/bin/bash

AFL_PRELOAD=./preeny/x86_64-linux-gnu/desock.so \
afl-fuzz \
    -i ./input/ \
    -o output/ \
    -x ./dict/ \
    -m2048 \
    ./redis/src/redis-server ./redis.conf
