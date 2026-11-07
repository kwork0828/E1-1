#!/usr/bin/env bash
# [요건6] hello-world / ubuntu 내부 진입 / attach·exec·start 차이 관찰
source "$(dirname "$0")/lib.sh"
{
section "04 컨테이너 실행 실습"
run 'docker run --rm hello-world | head -6'
echo "--- ubuntu 컨테이너 내부에서 간단한 명령 실행 (ls, echo) ---"
run 'docker run --rm ubuntu:22.04 bash -c "cat /etc/os-release | head -2; echo hi-from-container; ls /"'
echo "--- 종료/유지 차이: 포그라운드 프로세스가 끝나면 컨테이너도 종료(Exited) ---"
run 'docker rm -f t-exit t-keep >/dev/null 2>&1; docker run --name t-exit ubuntu:22.04 echo done'
run 'docker run -d --name t-keep ubuntu:22.04 sleep infinity'
run 'docker ps -a --filter name=t- --format "table {{.Names}}\t{{.Status}}\t{{.Command}}"'
echo "--- exec: 이미 실행 중인 컨테이너에 새 프로세스를 추가 (exit 해도 컨테이너는 유지) ---"
run 'docker exec t-keep bash -c "echo exec-ok; ps aux | head -5"'
run 'docker ps --filter name=t-keep --format "table {{.Names}}\t{{.Status}}"'
echo "--- attach: 컨테이너의 메인 프로세스(PID 1) 출력에 붙는다. sleep은 출력이 없어 지켜볼 내용 없음 ---"
run 'timeout -s KILL 3 docker attach --no-stdin --sig-proxy=false t-keep || echo "(3초 후 attach 해제, 컨테이너는 계속 실행)"'
run 'docker ps --filter name=t-keep --format "table {{.Names}}\t{{.Status}}"'
run 'docker rm -f t-exit t-keep'
} 2>&1 | tee "$LOG_DIR/04-container-practice.log"
