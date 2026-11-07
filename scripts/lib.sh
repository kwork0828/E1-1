#!/usr/bin/env bash
# 공통 헬퍼: 명령어를 "$ 명령" 형태로 먼저 찍고, 이어서 실제 출력을 보여준다. (증거 규칙: 명령 + 출력 동시 기록)
LOG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/docs/logs"
mkdir -p "$LOG_DIR"
run() {
  echo "\$ $*"
  eval "$@" 2>&1
  echo
}
section() { echo "=== $* ==="; echo; }
