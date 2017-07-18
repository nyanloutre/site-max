FROM nginx:alpine
RUN sed -i 's/#gzip/gzip/g' /etc/nginx/nginx.conf && \
    sed -i '/gzip *on/ a gzip_types text/css application/javascript image/svg+xml;' /etc/nginx/nginx.conf && \
    apk add --no-cache sassc nodejs build-base ffmpeg git coreutils bash && \
    npm install -g svg-sprite-generator && \
    
    git clone https://github.com/gpac/gpac.git && \
    cd gpac && \
    ./configure --static-mp4box --use-zlib=no && \
    make && \
    make install

COPY video/ /usr/share/nginx/html/video/
WORKDIR /usr/share/nginx/html/video
RUN ./mpd_generate.sh 1_Compilation_Graphique.webm
    
COPY . /usr/share/nginx/html
WORKDIR /usr/share/nginx/html
RUN sassc -m -t compressed scss/creative.scss css/creative.css && \
    svg-sprite-generate -d vector/ -o vector/sprite.svg
