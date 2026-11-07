#!/usr/bin/env bash
# [요건9] Docker 볼륨 영속성: 컨테이너 삭제 전/후 데이터 유지 증명
source "$(dirname "$0")/lib.sh"
{
section "07 Docker 볼륨 영속성 검증"
run 'docker rm -f vol-test vol-test2 >/dev/null 2>&1; docker volume rm mydata >/dev/null 2>&1; docker volume create mydata'
run 'docker volume ls --filter name=mydata'
run 'docker run -d --name vol-test -v mydata:/data ubuntu:22.04 sleep infinity'
run 'docker exec vol-test bash -lc "echo hi > /data/hello.txt && cat /data/hello.txt"'
echo "--- 컨테이너 삭제 ---"
run 'docker rm -f vol-test'
run 'docker ps -a --filter name=vol-test'
echo "--- 새 컨테이너에 같은 볼륨 연결 후 데이터 확인 ---"
run 'docker run -d --name vol-test2 -v mydata:/data ubuntu:22.04 sleep infinity'
run 'docker exec vol-test2 bash -lc "cat /data/hello.txt"'
run 'docker volume inspect mydata --format "{{.Name}} {{.Driver}} {{.Mountpoint}}"'
echo "--- 대조군: 볼륨 없이 쓴 데이터는 컨테이너와 함께 사라진다 ---"
run 'docker run -d --name no-vol ubuntu:22.04 sleep infinity; docker exec no-vol bash -lc "echo temp > /tmp/x.txt && cat /tmp/x.txt"; docker rm -f no-vol; docker run --rm ubuntu:22.04 bash -lc "cat /tmp/x.txt || echo \"파일 없음 - 컨테이너와 함께 삭제됨\""'
run 'docker rm -f vol-test2; docker volume rm mydata'
} 2>&1 | tee "$LOG_DIR/07-volume.log"
