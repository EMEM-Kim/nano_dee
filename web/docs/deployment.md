# GitHub Pages 배포

GitHub Actions에서 HTML을 빌드하고 GitHub Pages로 배포했다. 2026-10-23 [배포 실행](https://github.com/EMEM-Kim/nano_dee/actions/runs/39886029655)이 성공했다.

| 용도 | 주소 |
|---|---|
| 그래프 | https://emem-kim.github.io/nano_dee/graph.html |
| 대시보드 | https://emem-kim.github.io/nano_dee/dashboard.html |

## 배포 구조

- 워크플로 파일은 `.github/workflows/pages.yml`이다.
- main에 push하면 지표 테스트와 HTML 빌드를 실행한다.
- 수동 실행인 `workflow_dispatch`에서는 빌드 후 Pages 배포까지 실행한다.
- 배포 폴더 `_site`에는 `index.html`, `graph.html`, `dashboard.html`을 포함한다.
- SQL과 Markdown 문서는 GitHub 저장소에서 확인한다.

## 업데이트 절차

1. 수정한 파일을 main에 반영한다.
2. [Actions](https://github.com/EMEM-Kim/nano_dee/actions)에서 **Dashboard checks and deployment → Run workflow → main**을 선택한다.
3. build와 deploy 작업의 성공 여부 및 공개 화면을 확인한다.

Pages의 배포 소스는 [Settings → Pages](https://github.com/EMEM-Kim/nano_dee/settings/pages)의 **GitHub Actions**로 설정했다.
