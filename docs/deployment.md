# GitHub Pages 배포

소스와 제출 파일은 이 저장소에 있으며 `.github/workflows/pages.yml`이 `web/dist`를 배포합니다.

1. 저장소 소유자 계정으로 [Settings → Pages](https://github.com/EMEM-Kim/nano_dee/settings/pages)를 엽니다.
2. Build and deployment의 Source를 **GitHub Actions**로 선택합니다.
3. [Actions](https://github.com/EMEM-Kim/nano_dee/actions)에서 **Publish dashboard**를 선택하고 **Run workflow → main**을 실행합니다. 이전 실행이 실패했다면 설정 후 재실행합니다.
4. 배포 단계가 초록색으로 끝난 뒤 아래 URL을 열어 KPI와 필터를 확인합니다.

| 용도 | 배포 후 주소 |
|---|---|
| 1일차 그래프 | https://EMEM-Kim.github.io/nano_dee/graph.html |
| 2·3일차 대시보드 | https://EMEM-Kim.github.io/nano_dee/dashboard.html |

현재 환경에서는 저장소 파일 쓰기는 가능하지만 Pages 설정 API가 제공되지 않고 브라우저도 로그인되어 있지 않습니다. 위 설정이 완료되기 전 URL을 공개 완료로 제출하지 않습니다.

## Actions 파일 업로드가 제한된 경우

GitHub 연결 권한에 따라 워크플로 파일 쓰기가 제한될 수 있습니다. 이 경우 **Source: Deploy from a branch → main → /(root)**를 선택하면 루트의 `index.html`, `dashboard.html`, `graph.html`로 배포할 수 있습니다. 루트 파일은 제출용 파일과 동일하게 생성됩니다.
