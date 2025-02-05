FROM tomcat:9-jre9
COPY ./target/dev.war /usr/local/tomcat/webapps/