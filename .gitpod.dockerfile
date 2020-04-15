FROM gitpod/workspace-mysql

USER root
# Setup Heroku CLI
RUN curl https://cli-assets.heroku.com/install.sh | sh

# Setup MongoDB
# First line is Ubuntu 19.04 workaround

RUN curl https://mattrudge.net/files/sources.txt > /etc/apt/sources.list && \
    sudo apt-get update -y && \
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4 && \
    echo "deb http://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.0.list && \
    apt-get update -y && \
    touch /etc/init.d/mongod && \
    sudo apt-get -y install mongodb-org mongodb-org-server -y && \
    sudo apt-get -y install links && \
    sudo rm -rf /var/lib/apt/lists/*

USER gitpod
# Local environment variables
# C9USER is temporary to allow the MySQL Gist to run
ENV C9_USER="gitpod"
ENV PORT="8080"
ENV IP="0.0.0.0"
ENV C9_HOSTNAME="localhost"

USER root
# Switch back to root to allow IDE to load
