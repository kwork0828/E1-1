#!/usr/bin/env bash
# [요건7,8] Dockerfile 커스텀 이미지 빌드 + 포트 매핑 접속(2회)
source "$(dirname "$0")/lib.sh"
cd "$(dirname "$0")/.."
{
section "05 커스텀 이미지 빌드와 포트 매핑"
run 'cat Dockerfile'
run 'docker build -t my-web:1.0 . 2>&1 | tail -8'
run 'docker images my-web'
run 'docker rm -f my-web-8080 my-web-8081 >/dev/null 2>&1; docker run -d -p 8080:80 --name my-web-8080 my-web:1.0'
run 'docker run -d -p 8081:80 --name my-web-8081 my-web:1.0'
run 'sleep 4; docker ps --format "table {{.Names}}\t{{.Ports}}\t{{.Status}}"'
run 'curl -s -i http://localhost:8080 | head -12'
run 'curl -s http://localhost:8081'
run 'docker exec my-web-8080 printenv APP_ENV'
run 'docker inspect --format "{{.Config.Labels}}" my-web-8080'
run 'docker rm -f my-web-8080 my-web-8081'
} 2>&1 | tee "$LOG_DIR/05-custom-image-port.log"
