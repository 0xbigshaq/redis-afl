FROM aflplusplus/aflplusplus:latest

RUN mkdir /root/redis-dir
ADD fuzz.sh /root/redis-dir/
ADD hotpatch.diff /root/redis-dir/


ADD input/ /root/redis-dir/input/

# compile redis-server with debug info using afl clang compiler

RUN cd /root/redis-dir && \
    git clone https://github.com/redis/redis.git && \
    cd redis && \
    git checkout 92bde12 && \
    cd ../ && \
    patch -p1 -i ./hotpatch.diff && cd redis/ && \
    make MALLOC=libc CC=afl-clang-fast CXX=afl-clang-fast CFLAGS="-g3 -static" CXXFLAGS="-g3"


# fetch preeny, install deps & compile shared object files
RUN cd /root/redis-dir && \ 
    git clone https://github.com/zardus/preeny.git && \ 
    cd preeny && \  
    git checkout aaef77f94052aad5e4b019d7cbfd30aac323ccd7 && \
    apt-get update && \
    apt-get install -y libini-config-dev libseccomp-dev cmake && \
    make 



# creating a fuzzing dictionary
ADD setup.sh /root/redis-dir/

RUN cd /root/redis-dir/ && \
    chmod +x setup.sh && \
    chmod +x fuzz.sh && \
    ./setup.sh 

CMD sh -c '/bin/bash'