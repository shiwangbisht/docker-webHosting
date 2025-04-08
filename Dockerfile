FROM ubuntu:20.04

# Prevent interactive prompts during install
ARG DEBIAN_FRONTEND=noninteractive

# Update & install Apache
RUN apt-get update && \
    apt-get install -y apache2 && \
    apt-get clean

COPY 2137_barista_cafe/* /var/www/html

EXPOSE 8080

# Start Apache in foreground
CMD ["apachectl", "-D", "FOREGROUND"]