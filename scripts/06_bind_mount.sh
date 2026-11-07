#!/usr/bin/env bash
# [요건: 바인드 마운트] 호스트 파일을 바꾸면 컨테이너에 즉시 반영되는지 전/후 비교
source "$(dirname "$0")/lib.sh"
{
section "06 바인드 마운트 반영 증명"
rm -rf /tmp/bindsite && mkdir -p /tmp/bindsite && echo "<h1>BEFORE</h1>" > /tmp/bindsite/index.html
run 'docker rm -f bind-web >/dev/null 2>&1; docker run -d --name bind-web -p 8090:80 -v /tmp/bindsite:/usr/share/nginx/html:ro nginx:alpine'
run 'sleep 2; curl -s http://localhost:8090'
echo "--- 호스트에서 파일 수정 (컨테이너는 재시작하지 않음) ---"
run 'echo "<h1>AFTER (host edited)</h1>" > /tmp/bindsite/index.html'
run 'curl -s http://localhost:8090'
run 'docker inspect --format "{{range .Mounts}}{{.Type}} {{.Source}} -> {{.Destination}} (rw={{.RW}}){{end}}" bind-web'
run 'docker rm -f bind-web'
} 2>&1 | tee "$LOG_DIR/06-bind-mount.log"
