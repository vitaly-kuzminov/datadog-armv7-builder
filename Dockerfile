FROM golang:1.14.0

ENV VERSION 7.18.0
ENV GOARCH arm
ENV GOARM 7
ENV GOOS linux
ENV AGENT_FOLDER /go/src/github.com/DataDog/datadog-agent

# Agent checkout to $VERSION
RUN git clone https://github.com/DataDog/datadog-agent.git $AGENT_FOLDER -b $VERSION

# Install build dependencies (NOTE: still Python 2)
RUN apt-get update && apt-get install -y \
    python-pip \
    cmake && \
  rm -rf /var/lib/apt/lists/* && \
  curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh && \
  cd $AGENT_FOLDER && pip install -r requirements.txt

# Pull Agent dependencies
RUN cd $AGENT_FOLDER && \
  invoke deps && \
  mkdir target

# Set build tags: https://github.com/DataDog/datadog-agent/blob/master/tasks/agent.py#L68-L77
# It doesn't change pulled dependencies, so it's fine to reuse the cache above
ENV BUILD_TAGS cpu,disk,io,load,memory,network,ntp,uptime,docker,process

# Running the container means building the `puppy` Agent
CMD cd $AGENT_FOLDER && \
  GOOS=$GOOS GOARCH=$GOARCH GOARM=$GOARM invoke agent.build --build-include=$BUILD_TAGS && \
  mv bin/agent/dist bin/agent/datadog-agent && \
  mkdir bin/agent/dist -p && \
  mv bin/agent/datadog-agent/templates bin/agent/dist && \
  mv bin/agent/datadog-agent/views bin/agent/dist && \
  tar cvf ./target/agent-armv7-$VERSION.tar.gz -C bin/agent/ .
