#!/bin/bash

file=$1

if [[ -n "$file" ]]; then

    name=${file%.*}
    
    if [[ -d ${name} ]]; then
        read -p "Delete previous renders in ${name}/ ? y/n" delete
        
        case $delete in
        y|Y)
            echo "Deleting ${name}/ ..."
            rm -rf ${name}
            ;;
        *)
            echo "Terminating ..."
            exit 1
            ;;
        esac
    fi
    
    mkdir ${name}

    ffmpeg -i ${file} -c:a aac -ac 2 -ab 128k -vn ${name}/${name}-audio.mp4 &

    ffmpeg -i ${file} -an -c:v libx264 -x264opts 'keyint=24:min-keyint=24:no-scenecut' -b:v 5300k -maxrate 5300k -bufsize 2650k -vf 'scale=-1:1080' ${name}/${name}-1080.mp4 &
    
    ffmpeg -i ${file} -an -c:v libx264 -x264opts 'keyint=24:min-keyint=24:no-scenecut' -b:v 2400k -maxrate 2400k -bufsize 1200k -vf 'scale=-1:720' ${name}/${name}-720.mp4 &
    
    ffmpeg -i ${file} -an -c:v libx264 -x264opts 'keyint=24:min-keyint=24:no-scenecut' -b:v 1060k -maxrate 1060k -bufsize 530k -vf 'scale=-1:478' ${name}/${name}-480.mp4 &
    
    ffmpeg -i ${file} -an -c:v libx264 -x264opts 'keyint=24:min-keyint=24:no-scenecut' -b:v 600k -maxrate 600k -bufsize 300k -vf 'scale=-1:360' ${name}/${name}-360.mp4 &
    
    ffmpeg -i ${file} -an -c:v libx264 -x264opts 'keyint=24:min-keyint=24:no-scenecut' -b:v 260k -maxrate 260k -bufsize 130k -vf 'scale=-1:242' ${name}/${name}-240.mp4 &

    wait

    MP4Box -dash 1000 -rap -frag-rap -profile onDemand -out ${name}/${name}.mpd ${name}/${name}-1080.mp4 ${name}/${name}-720.mp4 ${name}/${name}-480.mp4 ${name}/${name}-360.mp4 ${name}/${name}-240.mp4 ${name}/${name}-audio.mp4

else
    echo "./mpd_generate.sh INPUT"
fi
