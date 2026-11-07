"""docs/README.template.md의 {{LOG:파일}} 자리에 docs/logs의 실제 로그를 끼워 README.md를 만든다.
(문서의 로그가 손으로 쓴 것이 아니라 실행 결과 그대로임을 보장하기 위한 스크립트)"""
import re, subprocess, pathlib
root = pathlib.Path(__file__).resolve().parent.parent
t = (root / "docs/README.template.md").read_text(encoding="utf-8")
sh = lambda c: subprocess.run(c, shell=True, capture_output=True, text=True).stdout.strip()
osr = sh('. /etc/os-release; echo "$PRETTY_NAME"')
t = t.replace("{{OS}}", osr + " (컨테이너)").replace("{{SHELL}}", sh("bash --version | head -1"))
t = t.replace("{{DOCKER}}", sh("docker --version")).replace("{{GIT}}", sh("git --version"))
def log(m):
    s = (root / "docs/logs" / m.group(1)).read_text(encoding="utf-8")
    s = re.sub(r"\n{3,}", "\n\n", s).strip()
    return s
t = re.sub(r"\{\{LOG:([^}]+)\}\}", log, t)
(root / "README.md").write_text(t, encoding="utf-8")
print("README.md written", len(t.splitlines()), "lines")
