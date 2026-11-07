"""docs/logs/*.log (실제 실행 로그)를 터미널 모양 PNG로 렌더링해 docs/screenshots/ 에 저장한다.

이미지는 로그 텍스트를 그대로 그린 것이라 내용이 로그와 항상 일치한다.
"""
import html
import pathlib
from playwright.sync_api import sync_playwright

root = pathlib.Path(__file__).resolve().parent.parent
TITLES = {
    "01-terminal": "01 터미널 기본 조작 (pwd / ls / mkdir / cp / mv / rm / cat)",
    "02-permissions": "02 파일 권한 실습 (chmod / Permission denied 재현)",
    "03-docker-basic": "03 Docker 설치 확인과 기본 운영",
    "04-container-practice": "04 컨테이너 실행·로그·exec·attach",
    "05-custom-image-port": "05 Dockerfile 커스텀 이미지 + 포트 매핑",
    "06-bind-mount": "06 바인드 마운트 (호스트 수정이 즉시 반영)",
    "07-volume": "07 Docker 볼륨 영속성 (컨테이너 삭제 후에도 유지)",
    "08-git": "08 Git 설정 (user.name / user.email / main)",
}
with sync_playwright() as p:
    browser = p.chromium.launch()
    page = browser.new_page(device_scale_factor=2)
    for stem, title in TITLES.items():
        text = (root / "docs/logs" / (stem + ".log")).read_text(encoding="utf-8").strip("\n")
        page.set_content(
            "<html><body style='margin:0;background:#1e1e1e'>"
            "<div style=\"display:inline-block;min-width:760px;font-family:'Noto Sans Mono CJK KR','Noto Sans CJK HK',monospace\">"
            "<div style='background:#333;color:#ddd;padding:6px 12px;font-size:13px;font-family:sans-serif'>"
            + html.escape(title) + "</div>"
            "<pre style='margin:0;padding:14px 18px;color:#e6e6e6;font-size:14px;line-height:1.4'>"
            + html.escape(text) + "</pre></div></body></html>")
        page.locator("div").first.screenshot(path=str(root / "docs/screenshots" / (stem + ".png")))
        print("rendered", stem)
    browser.close()
