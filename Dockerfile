FROM jupyter/base-notebook:python-3.7.6
# FROM continuumio/miniconda3
# FROM python:3.6

USER root
WORKDIR /luce

    
RUN apt update && \
    apt install -y wget build-essential software-properties-common libssl-dev  postgresql-client libpq-dev

# Install Ethereum
RUN add-apt-repository -y ppa:ethereum/ethereum && \
    apt update && \
    apt install -y ethereum

# RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /root/miniconda.sh
    

RUN conda install -y jupyter_contrib_nbextensions

COPY luce_vm /luce/

## Uncomment this line to use psql instead of SQLite
# ENV DJANGO_USE_PSQL=true

RUN pip install -r /luce/requirements.txt

# RUN python /luce/luce_django/luce/manage.py loaddata /luce/luce_django/luce/utils/fixtures/demo_all_v2.json

RUN mkdir -p /root/.local/share/jupyter/kernels/luce_vm/ && \
    cp /luce/.config/luce_jupyter_kernel.json /root/.local/share/jupyter/kernels/luce_vm/

# Enable jupyter extensions
RUN jupyter nbextension enable toc2/main && \
    # Table of content
    jupyter nbextension enable varInspector/main && \
    # Scratchpad (Ctrl+B)
    jupyter nbextension enable scratchpad/main && \
    # Python Markdown {{ var }} in md cells
    jupyter nbextension enable python-markdown/main

RUN python -m solcx.install v0.4.25

# Install Node
ENV NVM_DIR="/root/.nvm"
RUN mkdir -p /root/.nvm && \
    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" && \
    nvm install node

RUN npm install -g ganache-cli
RUN mkdir -p /root/.ganache_db && \
    cp /luce/.config/ganache_db/* /root/.ganache_db/

# RUN cp /luce/.config/ganache_db /root/.ganache_db


# Set up jupyter kernel for luce python environment
# The custom kernel allows us to introduce environment variables 
# for access to the Django context from within Jupyter
# pip install ipykernel
# python -m ipykernel install --user --name=luce_vm

# RUN wget -O /wait-for-it.sh https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh && \
#     chmod +x /wait-for-it.sh

EXPOSE 8000
EXPOSE 8888

ENTRYPOINT [ "/luce/entrypoint.sh" ]