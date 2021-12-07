FROM atlassian/bamboo-agent-base

RUN curl -fsSL https://deb.nodesource.com/setup_17.x | bash -

RUN apt-get install -y nodejs

RUN curl -sSL https://get.docker.com/ | sh
