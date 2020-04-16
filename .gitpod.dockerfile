FROM gitpod/workspace-full

USER root
# Setup Heroku CLI
RUN curl https://cli-assets.heroku.com/install.sh | sh

# Setup MongoDB and MySQL
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4 && \
    echo "deb http://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.0.list  && \
    apt-get update -y  && \
    touch /etc/init.d/mongod  && \
    apt-get -y install mongodb-org mongodb-org-server -y  && \
    apt-get update -y  && \
    apt-get -y install links  && \
    apt-get install -y mysql-server && \
    apt-get clean && rm -rf /var/cache/apt/* /var/lib/apt/lists/* /tmp/* && \
    mkdir /var/run/mysqld && \
    chown -R gitpod:gitpod /etc/mysql /var/run/mysqld /var/log/mysql /var/lib/mysql /var/lib/mysql-files /var/lib/mysql-keyring /var/lib/mysql-upgrade /home/gitpod/.cache/heroku/ && \
    pip3 install flake8

# Create our own config files

COPY .theia/mysql.cnf /etc/mysql/mysql.conf.d/mysqld.cnf

COPY .theia/client.cnf /etc/mysql/mysql.conf.d/client.cnf

COPY .theia/start_mysql.sh /etc/mysql/mysql-bashrc-launch.sh

USER gitpod

# Start MySQL when we log in

RUN echo ". /etc/mysql/mysql-bashrc-launch.sh" >> ~/.bashrc

# Local environment variables
# C9USER is temporary to allow the MySQL Gist to run
ENV C9_USER="gitpod"
ENV PORT="8080"
ENV IP="0.0.0.0"
ENV C9_HOSTNAME="localhost"

USER root
# Switch back to root to allow IDE to load
