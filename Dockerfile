FROM jenkins/jenkins:lts

USER root

RUN wget --no-verbose -O /tmp/apache-maven-3.5.4-bin.tar.gz http://apache.cs.utah.edu/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz

RUN tar xzf /tmp/apache-maven-3.5.4-bin.tar.gz -C /opt/
RUN ln -s /opt/apache-maven-3.5.4 /opt/maven
RUN ln -s /opt/maven/bin/mvn /usr/local/bin
RUN rm -f /tmp/apache-maven-3.5.4-bin.tar.gz
ENV MAVEN_HOME /opt/maven
RUN apt-get update -qq
RUN apt-get install -qqy
RUN apt-get install -f git
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/plugins.txt
COPY /configs/jenkins_home_config.xml "$JENKINS_HOME"/config.xml
ARG job_name_1="hello-service"
RUN mkdir -p "$JENKINS_HOME"/workspace/${job_name_1}
RUN mkdir -p "$JENKINS_HOME"/jobs/${job_name_1}
COPY /configs/${job_name_1}_config.xml "$JENKINS_HOME"/jobs/${job_name_1}/config.xml
RUN mkdir -p "$JENKINS_HOME"/jobs/${job_name_1}/latest/
RUN mkdir -p "$JENKINS_HOME"/jobs/${job_name_1}/builds/1/

USER jenkins