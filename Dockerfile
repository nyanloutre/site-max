FROM nginx:alpine
RUN sed -i 's/#gzip/gzip/g' /etc/nginx/nginx.conf
COPY . /usr/share/nginx/html 
