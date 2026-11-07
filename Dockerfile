# (A) 방식: 웹 서버 베이스 이미지(nginx:alpine) + 정적 콘텐츠/설정만 교체
FROM nginx:alpine
LABEL org.opencontainers.image.title="my-custom-nginx"
# 커스텀 포인트 1: 환경변수 (설정과 코드를 분리하는 습관)
ENV APP_ENV=dev
# 커스텀 포인트 2: 기본 nginx 페이지를 우리 정적 사이트로 교체
COPY site/ /usr/share/nginx/html/
# 커스텀 포인트 3: 컨테이너 상태 점검(헬스체크)
HEALTHCHECK --interval=5s --timeout=2s --retries=3 CMD wget -qO- http://localhost/ >/dev/null || exit 1
EXPOSE 80
