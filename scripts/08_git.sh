#!/usr/bin/env bash
# [요건10,11] Git 사용자 정보/기본 브랜치 설정 + git config --list (민감정보 마스킹)
source "$(dirname "$0")/lib.sh"
{
section "08 Git 설정 로그"
run 'git --version'
run 'git config --global init.defaultBranch main'
run 'git config user.name'
run 'git config user.email'
run 'git branch --show-current'
run 'git remote -v | sed -E "s#//[^@/]+@#//***@#"'
echo "--- git config --list (이 저장소 로컬 설정만 출력. 토큰/비밀번호 없음, 이메일은 GitHub noreply 주소) ---"
run 'git config --local --list'
run 'git config --global --get init.defaultBranch'
} 2>&1 | tee "$LOG_DIR/08-git.log"
