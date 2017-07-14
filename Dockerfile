FROM nginx:alpine
RUN sed -i 's/#gzip/gzip/g' /etc/nginx/nginx.conf && \
    sed -i '/gzip *on/ a gzip_types text/css application/javascript' /etc/nginx/nginx.conf
COPY . /usr/share/nginx/html 
