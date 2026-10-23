# GitHub Pages 배포

2026-10-23 확인: 기존 실행은 테스트·빌드에 성공했으나 configure-pages에서 **Pages site Not Found**로 실패했다. 현재 저장소는 비공개이며 공개 URL은 아직 검증되지 않았다.

## 최초 설정
1. [Settings → Pages](https://github.com/EMEM-Kim/nano_dee/settings/pages)에서 사용 가능 여부를 확인한다. GitHub Free는 공개 저장소에서 Pages를 지원하며, 비공개 저장소는 Pro 등 지원 요금제가 필요하다. 저장소 공개 여부는 소유자가 결정한다.
2. Build and deployment → Source를 **GitHub Actions**로 선택한다.
3. [Actions](https://github.com/EMEM-Kim/nano_dee/actions)에서 **Dashboard checks and deployment → Run workflow → main**을 실행한다.
4. deploy 작업이 성공하면 아래 주소를 열어 확인한 뒤 제출한다.

| 용도 | 배포 후 주소 |
|---|---|
| 그래프 | https://EMEM-Kim.github.io/nano_dee/graph.html |
| 대시보드 | https://EMEM-Kim.github.io/nano_dee/dashboard.html |

push 때는 검사·빌드만 실행하며, 실제 배포는 Run workflow로 실행한다. _site 폴더에는 HTML 3개만 담아 SQL·문서를 사이트에 함께 배포하지 않는다.

현재 GitHub 연결 도구는 Pages 설정 변경을 지원하지 않아 소유자 계정의 위 설정이 필요하다. [공식 Pages 지원 범위](https://docs.github.com/en/pages/getting-started-with-github-pages/what-is-github-pages)
