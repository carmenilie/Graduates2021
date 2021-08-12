FROM tomcat:8.0-alpine

LABEL maintainer=”deepak@softwareyoga.com”

ADD target/hello.war /usr/local/tomcat/webapps/

EXPOSE 8081

CMD [“catalina.sh”, “run”]