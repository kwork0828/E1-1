#!/usr/bin/env bash
# [요건2] 터미널 조작: 위치/목록(숨김 포함)/이동/생성/복사/이동·이름변경/삭제/내용확인/빈 파일 생성
source "$(dirname "$0")/lib.sh"
{
section "01 터미널 기본 조작 로그"
cd ~ ; run 'rm -rf ~/codyssey'          # 재실행해도 같은 결과가 나오도록 초기화(재현성)
run 'pwd'
run 'mkdir -p ~/codyssey/practice/docs ~/codyssey/practice/src'
run 'cd ~/codyssey/practice && pwd'
cd ~/codyssey/practice
run 'touch empty.txt .hidden_config'
run 'ls'
run 'ls -la'
run 'echo "hello codyssey" > docs/note.txt'
run 'cat docs/note.txt'
run 'cp docs/note.txt docs/note_copy.txt'
run 'mv docs/note_copy.txt src/renamed_note.txt'
run 'ls -R .'
run 'echo "[절대경로] 어디서든 같은 대상:" && ls /home/$(whoami)/codyssey/practice/docs'
run 'cd docs && echo "[상대경로] 현재 위치 기준:" && ls ../src && cd ..'
run 'rm src/renamed_note.txt'
run 'rm -r src'
run 'ls -la'
} 2>&1 | tee "$LOG_DIR/01-terminal.log"
