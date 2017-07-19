#!/bin/bash

file=$1
option=$2

if [[ -n "$file" ]]; then

    name=${file%.*}
    
    if [[ -d ${name} ]]; then
        case $option in
            --force)
                echo "Deleting ${name}/ ..."
                rm -rf ${name}
                ;;
            *)
                echo "Please use the --force option to overwrite existing data"
                exit 1
                ;;
            esac
    fi
    
    mkdir -p ${name}

    ffmpeg -i ${file} -c:a aac -ac 2 -ab 128k -vn ${name}/${name}-audio.mp4 &

    ffmpeg -i ${file} -s 1920x1080 -c:v libx264 -b:v 5500k -x264opts 'keyint=50:min-keyint=50:no-scenecut' -profile:v main -preset fast -movflags +faststart ${name}/${name}-1080.mp4 &
    
    ffmpeg -i ${file} -s 1280x720 -c:v libx264 -b:v 2500k -x264opts 'keyint=50:min-keyint=50:no-scenecut' -profile:v main -preset fast -movflags +faststart ${name}/${name}-720.mp4 &
    
    ffmpeg -i ${file} -s 960x540 -c:v libx264 -b:v 1400k -x264opts 'keyint=50:min-keyint=50:no-scenecut' -profile:v main -preset fast -movflags +faststart ${name}/${name}-540.mp4 &
    
    ffmpeg -i ${file} -s 640x360 -c:v libx264 -b:v 650k -x264opts 'keyint=50:min-keyint=50:no-scenecut' -profile:v main -preset fast -movflags +faststart ${name}/${name}-360.mp4 &

    wait

    MP4Box -dash 4000 -rap -bs-switching no -profile live -out ${name}/${name}.mpd ${name}/${name}-1080.mp4 ${name}/${name}-720.mp4 ${name}/${name}-540.mp4 ${name}/${name}-360.mp4 ${name}/${name}-audio.mp4

else
    echo "./mpd_generate.sh INPUT"
fi
