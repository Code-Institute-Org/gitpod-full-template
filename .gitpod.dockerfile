FROM gitpod/workspace-base:latest

RUN echo "CI version from base"

### NodeJS ###
USER gitpod
ENV NODE_VERSION=16.13.0
ENV TRIGGER_REBUILD=1
RUN curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | PROFILE=/dev/null bash \
    && bash -c ". .nvm/nvm.sh \
        && nvm install $NODE_VERSION \
        && nvm alias default $NODE_VERSION \
        && npm install -g typescript yarn node-gyp" \
    && echo ". ~/.nvm/nvm.sh"  >> /home/gitpod/.bashrc.d/50-node
ENV PATH=$PATH:/home/gitpod/.nvm/versions/node/v${NODE_VERSION}/bin

### Python ###
USER gitpod
RUN sudo install-packages python3-pip

ENV PATH=$HOME/.pyenv/bin:$HOME/.pyenv/shims:$PATH
RUN curl -fsSL https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash \
    && { echo; \
        echo 'eval "$(pyenv init -)"'; \
        echo 'eval "$(pyenv virtualenv-init -)"'; } >> /home/gitpod/.bashrc.d/60-python \
    && pyenv update \
    && pyenv install 3.8.11 \
    && pyenv global 3.8.11 \
    && python3 -m pip install --no-cache-dir --upgrade pip \
    && python3 -m pip install --no-cache-dir --upgrade \
        setuptools wheel virtualenv pipenv pylint rope flake8 \
        mypy autopep8 pep8 pylama pydocstyle bandit notebook \
        twine \
    && sudo rm -rf /tmp/*USER gitpod
ENV PYTHONUSERBASE=/workspace/.pip-modules \
    PIP_USER=yes
ENV PATH=$PYTHONUSERBASE/bin:$PATH

# Setup Heroku CLI
RUN curl https://cli-assets.heroku.com/install.sh | sh

# Setup MongoDB
RUN sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 20691eec35216c63caf66ce1656408e390cfb1f5 && \
    sudo sh -c 'echo "deb http://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list'  && \
    sudo apt-get update -y  && \
    sudo touch /etc/init.d/mongod  && \
    sudo apt-get install -y mongodb-org-shell  && \
    sudo apt-get install -y links  && \
    sudo apt-get clean -y && \
    sudo rm -rf /var/cache/apt/* /var/lib/apt/lists/* /tmp/* && \
    sudo chown -R gitpod:gitpod /home/gitpod/.cache/heroku/

# Setup PostgreSQL

RUN sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" | tee /etc/apt/sources.list.d/pgdg.list' && \
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8 && \
    sudo apt-get update -y && \
    sudo apt-get install -y postgresql-12

ENV PGDATA="/workspace/.pgsql/data"

RUN mkdir -p ~/.pg_ctl/bin ~/.pg_ctl/sockets \
    && echo '#!/bin/bash\n[ ! -d $PGDATA ] && mkdir -p $PGDATA && initdb --auth=trust -D $PGDATA\npg_ctl -D $PGDATA -l ~/.pg_ctl/log -o "-k ~/.pg_ctl/sockets" start\n' > ~/.pg_ctl/bin/pg_start \
    && echo '#!/bin/bash\npg_ctl -D $PGDATA -l ~/.pg_ctl/log -o "-k ~/.pg_ctl/sockets" stop\n' > ~/.pg_ctl/bin/pg_stop \
    && chmod +x ~/.pg_ctl/bin/*

# ENV DATABASE_URL="postgresql://gitpod@localhost"
# ENV PGHOSTADDR="127.0.0.1"
ENV PGDATABASE="postgres"

ENV PATH="/usr/lib/postgresql/12/bin:/home/gitpod/.nvm/versions/node/v${NODE_VERSION}/bin:$HOME/.pg_ctl/bin:$PATH"


# Add aliases

RUN echo 'alias run="python3 $GITPOD_REPO_ROOT/manage.py runserver 0.0.0.0:8000"' >> ~/.bashrc && \
    echo 'alias heroku_config=". $GITPOD_REPO_ROOT/.vscode/heroku_config.sh"' >> ~/.bashrc && \
    echo 'alias python=python3' >> ~/.bashrc && \
    echo 'alias pip=pip3' >> ~/.bashrc && \
    echo 'alias arctictern="python3 $GITPOD_REPO_ROOT/.vscode/arctictern.py"' >> ~/.bashrc && \
    echo 'alias font_fix="python3 $GITPOD_REPO_ROOT/.vscode/font_fix.py"' >> ~/.bashrc && \
    echo 'alias set_pg="export PGHOSTADDR=127.0.0.1"' >> ~/.bashrc && \
    echo 'alias mongosh=mongo' >> ~/.bashrc && \
    echo 'alias make_url="python3 $GITPOD_REPO_ROOT/.vscode/make_url.py "' >> ~/.bashrc && \
    echo 'FILE="$GITPOD_REPO_ROOT/.vscode/post_upgrade.sh"' >> ~/.bashrc && \
    echo 'if [ -z "$POST_UPGRADE_RUN" ]; then' >> ~/.bashrc && \
    echo '  if [[ -f "$FILE" ]]; then' >> ~/.bashrc && \
    echo '    . "$GITPOD_REPO_ROOT/.vscode/post_upgrade.sh"' >> ~/.bashrc && \
    echo "  fi" >> ~/.bashrc && \
    echo "fi" >> ~/.bashrc

# Local environment variables
# C9USER is temporary to allow the MySQL Gist to run
ENV C9_USER="root"
ENV PORT="8080"
ENV IP="0.0.0.0"
ENV C9_HOSTNAME="localhost"
# Despite the scary name, this is just to allow React and DRF to run together on Gitpod
ENV DANGEROUSLY_DISABLE_HOST_CHECK=true
