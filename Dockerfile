# Dockerfile for netprobe_lite
# https://github.com/plaintextpackets/netprobe_lite/
FROM python:3.13-alpine

ENV PYTHONUNBUFFERED=1

# install ip utils to get a ping with jitter data in the output
RUN apk add iputils

# Install uv (https://github.com/astral-sh/uv)
COPY --from=ghcr.io/astral-sh/uv:python3.13-alpine /usr/local/bin/uv /usr/local/bin/uvx /bin/

WORKDIR /netprobe_lite

COPY requirements.txt ./requirements.txt

# create virtualenv and install packages
RUN uv venv
RUN uv pip install -r ./requirements.txt

# copy python files into the container
COPY entrypoint.sh ./entrypoint.sh
COPY *.py ./
COPY helpers ./helpers
COPY config/__init__.py ./config/__init__.py
COPY logs ./logs

ENTRYPOINT [ "/bin/sh", "./entrypoint.sh" ]
