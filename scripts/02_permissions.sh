#!/usr/bin/env bash
# [요건3] 권한 실습: 파일 1개 + 디렉토리 1개, 변경 전/후 비교 (chmod 숫자/기호 방식)
source "$(dirname "$0")/lib.sh"
{
section "02 권한 실습 로그"
mkdir -p ~/codyssey/perm && cd ~/codyssey/perm && rm -rf ./*
run 'echo "echo script ran" > run.sh && mkdir secret_dir'
echo "--- [파일] 변경 전 ---"
run 'ls -l run.sh'
run './run.sh || echo "실행 실패(Permission denied) → x 권한이 없기 때문"'
run 'chmod 755 run.sh'
echo "--- [파일] 755 적용 후 (rwxr-xr-x) ---"
run 'ls -l run.sh'
run './run.sh'
run 'chmod 644 run.sh'
echo "--- [파일] 644 적용 후 (rw-r--r--) : 다시 실행 불가 ---"
run 'ls -l run.sh'
run './run.sh || echo "실행 실패 → 644에는 x가 없다"'
echo "--- [디렉토리] 변경 전 ---"
run 'ls -ld secret_dir'
run 'chmod 700 secret_dir'
echo "--- [디렉토리] 700 적용 후 (rwx------) 소유자만 접근 ---"
run 'ls -ld secret_dir'
run 'chmod u-x secret_dir'
echo "--- [디렉토리] 기호 방식 u-x : 소유자 실행(x) 제거 → cd 불가 (root가 아닌 일반 사용자 기준) ---"
run 'ls -ld secret_dir'
run 'cd secret_dir || echo "cd 실패 → 디렉토리는 x 권한이 있어야 들어갈 수 있다"'
run 'chmod u+x secret_dir && ls -ld secret_dir'
echo "r=4, w=2, x=1 → 7=rwx, 5=r-x, 4=r--, 6=rw-"
} 2>&1 | tee "$LOG_DIR/02-permissions.log"
