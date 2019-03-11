
FROM ubuntu:latest

# Install dependencies
RUN apt-get update -qq && apt-get install -y python3-pip build-essential gfortran make cmake git
RUN pip3 install numpy pytest

# Clone the project
RUN git clone --recursive -b demo/github_actions https://github.com/rafmudaf/sqrt.git rafmudaf/sqrt

# Build the project
RUN mkdir rafmudaf/sqrt/build
WORKDIR /rafmudaf/sqrt/build
RUN cmake ..
RUN make
WORKDIR /rafmudaf/sqrt
