#!/usr/bin/env bash
# [요건4,5] Docker 설치/기본 점검 + 이미지/컨테이너/로그/리소스 확인
source "$(dirname "$0")/lib.sh"
{
section "03 Docker 설치 점검 및 기본 운영 명령"
run 'docker --version'
run 'docker info | head -12'
run 'docker images'
run 'docker ps'
run 'docker ps -a | head -5'
run 'docker rm -f demo-nginx >/dev/null 2>&1; docker run -d --name demo-nginx nginx:alpine'
run 'sleep 2; docker ps'
run 'docker logs demo-nginx | head -5'
run 'docker stats --no-stream demo-nginx'
run 'docker stop demo-nginx'
run 'docker ps -a --filter name=demo-nginx'
run 'docker rm demo-nginx'
} 2>&1 | tee "$LOG_DIR/03-docker-basic.log"
