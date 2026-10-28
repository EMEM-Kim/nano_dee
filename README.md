# SQL 분석과 AI Agent 활용 프로젝트

건강보험 청구·폐암 합성 데이터를 SQL로 분석하고, AI 코딩 에이전트를 활용해 **CareLens 청구 현황 대시보드**를 제작한 4주 과정의 학습 결과물이다. 데이터 조회와 집계에서 시작해 웹 시각화, 검증, GitHub Pages 배포까지 진행했다.

[대시보드 실행](https://emem-kim.github.io/nano_dee/dashboard.html) · [그래프 실행](https://emem-kim.github.io/nano_dee/graph.html) · [최종 결과 문서](reports/final-report.md)

## 프로젝트 구성

| 구분 | 내용 | 시작 문서 |
|---|---|---|
| WEEK 1~2 · SQL | 조회·조건 검색·JOIN·집계·윈도우 함수·코호트 분석 | [SQL README](sql/README.md) |
| WEEK 3~4 · AI Agent 활용 | ChatGPT Codex를 활용한 대시보드 제작·검증·배포 | [AI 활용 README](web/README.md) |
| 최종 정리 | 결과물, 검증 결과, 4주간 배운 점 | [최종 보고서](reports/final-report.md), [학습 정리](reports/learning-summary.md) |

## 주요 결과

| 항목 | 결과 |
|---|---|
| 청구 명세서 | 38,375건 |
| 총 진료비 | 3,293,580,300원 |
| 고유 수진자 | 2,970명 |
| 호흡기 청구 월별 추세 | 2024~2025년 24개월 |
| 계절별 비교 | 11~3월 월평균이 6~9월의 약 2.17배 |
| SQL 분석 결과 | 외래·입원 분석, 상병별 집계, 재방문 간격, 병기별 사망 기록 |

데이터는 수업용 가상·합성 데이터이다. 명세서 수와 고유 수진자 수를 구분했고, 기관 종별 진료비는 중증도와 입원 비중을 보정하지 않은 평균으로 해석했다.

## 사용 기술과 기능

- **SQL:** MySQL 8.4, JOIN, GROUP BY, HAVING, CTE, CASE, 윈도우 함수
- **AI 제작 지원:** ChatGPT Codex
- **웹:** HTML, CSS, JavaScript, SVG
- **전처리·검증:** Python, openpyxl, Node.js
- **배포:** GitHub Actions, GitHub Pages

대시보드는 KPI 3개와 차트 3개를 제공한다. 연도·기관 종별·상병 범위를 선택하면 모든 지표를 다시 집계하며, 월별 결과를 표와 CSV로 확인할 수 있다. 최종 HTML은 데이터를 포함한 정적 결과물이다.

## 주차별 To-Do

### WEEK 1 · SQL 학습

- [x] 조회·조건 검색·GROUP BY·JOIN·집계 학습 — [학습 내용](sql/README.md)

### WEEK 2 · SQL 실습 및 결과물 정리

- [x] SQL 추가·심화 실습 수행 — [방문 간격·코호트·병기별 치료 실습](sql/practice/practice_1-5.sql)
- [x] 기존 과제 또는 실습 결과물 보완 — [문제 해결과 보완 내용](sql/README.md#5-문제-해결)
- [x] SQL 결과물 정리 — [분석 결과](sql/results/analysis.md), [실행 출력](sql/results/results.txt)
- [x] SQL 결과물 GitHub 업로드 — [과제 1~3](sql/assignments/)
- [x] README 작성 — [8개 항목의 SQL README](sql/README.md)

### WEEK 3 · AI Agent 학습

- [x] AI 코딩 에이전트를 활용한 요구사항 전달·제작·검증 과정 정리 — [제작 구조](web/README.md#4-agent-구조)

### WEEK 4 · AI Agent 결과물 및 최종 정리

- [x] 최종 결과물 정리 — [대시보드](web/output/dashboard.html), [그래프](web/output/graph.html)
- [x] GitHub 업로드 — [웹 소스와 문서](web/)
- [x] README 작성 — [10개 항목의 AI 활용 README](web/README.md)
- [x] 4주간 학습 결과 작성 — [학습 정리](reports/learning-summary.md)
- [x] 최종 결과 문서 작성 — [최종 보고서](reports/final-report.md)
- [ ] 최종 결과물 제출

## 파일 안내

| 위치 | 포함 내용 |
|---|---|
| `sql/` | SQL README, 실습, 과제, 실행 출력과 분석 결과 |
| `web/` | AI 활용 README, 웹 소스, 전처리·테스트·빌드, 제작 문서 |
| `reports/` | 최종 결과 문서와 4주간 학습 정리 |
| `web/output/` | 최종 HTML 3개 · 배포 시 기존 제출 URL 유지 |
| `.github/` | 검사·배포 자동화 |

SQL 설명은 `sql/README.md`, AI 활용 설명은 `web/README.md`에서 시작한다. 회고·프롬프트·배포 문서는 `web/docs/`, SQL 상세 결과는 `sql/results/`로 모았다.

## 실행 및 검증

결과물은 공개 링크에 접속하거나 HTML 파일을 브라우저로 열어 확인한다. 소스 수정 후에는 저장소 루트에서 Node.js 22 이상으로 실행한다.

```sh
node web/test.mjs
node web/build.mjs
```

전체 집계와 2025년·의원 필터 결과, 24개월 집계 여부를 검사한다. 실제 Pages 배포는 GitHub Actions의 **Dashboard checks and deployment → Run workflow**로 실행한다. 원자료 준비와 상세 실행 방법은 각 프로젝트 README에 정리했다.

## 출처

[강의 자료](https://app.notion.com/p/40163fd59006804f94a9eb6b49e8785a) · [청구 데이터](https://docs.google.com/spreadsheets/d/1nPuY8AKFAs2r9da4xUBV3WMKdLEBZJGpmd3kP7xKNvU) · [SQL 원본 자료](https://drive.google.com/drive/folders/1zM91ATIR5OSxSAlfF442GDovxkQ8f7tP) · [구성 참고 저장소](https://github.com/jihyeongh21-svg/nano-dree-sql)
