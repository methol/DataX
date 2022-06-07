# step 1 maven build
FROM maven:3-openjdk-8-slim AS builder

RUN mvn -q -U clean package assembly:assembly -Dmaven.test.skip=true \
        #拷贝编译结果到指定目录
        && mv target/datax/datax /datax


# step 2
FROM amd64/openjdk:8-slim

ENV TZ=Asia/Shanghai
RUN set -eux; \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime; \
    echo $TZ > /etc/timezone \
    apt-get install python

# Copy our static executable.
COPY --from=builder /datax /datax

ENV PATH=/datax/bin:$PATH

# 启动命令
ENTRYPOINT ["datax.py"]
CMD ["--help"]