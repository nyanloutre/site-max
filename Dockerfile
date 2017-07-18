FROM nginx:alpine
RUN sed -i 's/#gzip/gzip/g' /etc/nginx/nginx.conf && \
    sed -i '/gzip *on/ a gzip_types text/css application/javascript image/svg+xml;' /etc/nginx/nginx.conf && \
    apk add --no-cache sassc nodejs && \
    npm install -g svg-sprite-generator
COPY . /usr/share/nginx/html
WORKDIR /usr/share/nginx/html
RUN sassc -m -t compressed scss/creative.scss css/creative.css && \
    svg-sprite-generate -d vector/ -o vector/sprite.svg
