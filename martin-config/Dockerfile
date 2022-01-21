FROM --platform=linux/amd64 python:3.9-slim as python-base
LABEL name="docker-martin-config"
LABEL maintainer="Jin Igarashi <jin.igarashi@undp.org>"

# Setup env
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONFAULTHANDLER 1

WORKDIR /home/undp/app

# Install pipenv and compilation dependencies
RUN apt-get update && apt-get install -y --no-install-recommends git
RUN python -m pip install --upgrade pip
RUN pip install pipenv
RUN git clone https://github.com/UNDP-Data/martin-config.git &&\
    cd martin-config &&\
    pipenv install --system &&\
    python setup.py install &&\
    cd .. &&\
    rm -rf martin-config

COPY entrypoint.sh entrypoint.sh

WORKDIR /home/undp/app

CMD ["/bin/bash"]