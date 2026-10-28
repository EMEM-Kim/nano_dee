# 헬스케어 데이터 분석 학습 프로젝트

건강보험 청구 데이터와 폐암 합성 데이터를 활용해 **SQL 학습, 데이터 분석, 웹 시각화, 결과물 배포**를 진행한 4주 과정의 실습·과제 저장소이다. 데이터를 조회하고 집계하는 방법을 익힌 뒤, 분석 결과를 해석하고 다른 사람이 확인할 수 있는 문서와 웹 화면으로 정리했다.

SQL 실습과 과제, 청구 현황 대시보드, 학습 기록을 함께 관리한다. 분야별 구현 내용과 문제 해결 과정은 각 폴더의 README에 정리했다.

[SQL 프로젝트](sql/README.md) · [웹 프로젝트](web/README.md) · [최종 결과 문서](reports/final-report.md) · [4주간 학습 정리](reports/learning-summary.md)

## 학습 목표

- SQL로 필요한 데이터를 조회하고 여러 테이블을 연결해 분석 대상을 구성한다.
- 집계 단위와 조건을 정의하고, 결과가 질문에 맞는지 검증한다.
- 분석 목적에 맞는 지표와 차트를 선택해 결과를 전달한다.
- 코드·실행 결과·문서를 정리하고 GitHub를 통해 공유한다.

## 학습 과정

| 단계 | 주요 내용 | 결과물 |
|---|---|---|
| WEEK 1 · SQL 학습 | 데이터 조회, 조건 검색, JOIN, GROUP BY, 집계 | 기본 실습 쿼리 |
| WEEK 2 · SQL 실습 및 정리 | 방문 간격·누적 값·코호트 분석, 과제 보완, 결과 해석 | 실습·과제 SQL, 실행 출력, SQL README |
| WEEK 3 · AI Agent 학습 | 요구사항 구체화, AI 코딩 도구를 활용한 제작과 검증 | 그래프·대시보드 소스, 재현 프롬프트 |
| WEEK 4 · 결과물 및 최종 정리 | 웹 결과물 배포, 문서 보완, 학습 내용 정리 | 공개 대시보드, 최종 보고서, 회고 |

주차별 세부 진행 항목은 [학습 정리](reports/learning-summary.md)에 기록했다.

## 데이터와 분석 범위

| 데이터 | 규모 | 분석 내용 |
|---|---|---|
| 건강보험 청구 데이터 `kr_claims` | 2024~2025년 명세서 38,375건 | 외래·입원 조회, 상병·기관 종별 집계, 재방문 간격, 월별 추세 |
| 폐암 합성 데이터 `kr_lung_cancer` | 환자 9,897명 | 최초 진단 코호트, 병기별 치료와 사망 기록 |

수업용 가상·합성 데이터를 사용했다. 결과는 제공된 데이터 안에서 관찰한 값이며 실제 환자 기록이나 전국 통계를 의미하지 않는다.

## 주요 결과물

### SQL 실습과 분석

조회·조건 검색부터 윈도우 함수와 CTE를 활용한 분석까지 실습하고, 과제 3개를 작성했다. 실행 출력과 해석을 함께 정리해 쿼리의 계산 기준과 결과를 확인할 수 있도록 했다.

- 2025년 7월 외래 명세서 **1,450건**을 조회했다.
- E119 외래에서 이전 방문과 90일을 초과한 재방문 **1건, 94일**을 확인했다.
- 2010~2017년 최초 진단 폐암 환자 **6,873명**의 병기별 사망 기록을 분석했다.

[SQL 학습·과제 설명](sql/README.md) · [실행 결과와 해석](sql/results/analysis.md)

### 웹 그래프와 대시보드

청구 규모와 상병 구성, 계절별 진료 수요를 살펴보는 **CareLens 대시보드**와 호흡기 질환의 월별 그래프를 제작했다. 필터와 차트를 통해 데이터를 탐색하고 월별 집계를 CSV로 확인할 수 있도록 구성했다.

- 전체 명세서 **38,375건**, 총 진료비 **3,293,580,300원**, 고유 수진자 **2,970명**을 집계했다.
- 호흡기 질환 청구의 **24개월 추세**와 계절별 월평균을 비교했다.
- 전체·조건별 집계 결과를 검산하고 단독 실행 HTML로 배포했다.

[웹 프로젝트 설명](web/README.md) · [대시보드 실행](https://emem-kim.github.io/nano_dee/dashboard.html) · [그래프 실행](https://emem-kim.github.io/nano_dee/graph.html)

### 학습 기록과 최종 문서

분석과 제작 과정에서 배운 점, 결과 해석, 향후 적용 아이디어를 정리했다.

[최종 결과 문서](reports/final-report.md) · [4주간 학습 결과](reports/learning-summary.md) · [강의 회고](web/docs/reflection.md)

## 사용 기술

| 분야 | 기술 |
|---|---|
| 데이터 조회·분석 | SQL, MySQL 8.4 |
| 데이터 전처리 | Python, openpyxl |
| 웹 시각화 | HTML, CSS, JavaScript, SVG |
| 제작 지원 | ChatGPT Codex |
| 검증·빌드 | Node.js |
| 버전 관리·배포 | GitHub, GitHub Actions, GitHub Pages |

기술별 사용 목적과 실행 방법은 [SQL README](sql/README.md)와 [웹 README](web/README.md)에 정리했다.

## 저장소 구성

| 폴더 | 내용 |
|---|---|
| [sql/](sql/) | SQL README, 기본·심화 실습, 과제, 실행 결과와 분석 |
| [web/](web/) | 웹 README, 소스 코드, 전처리·검증·빌드, 제작 문서 |
| [web/output/](web/output/) | 그래프·대시보드 최종 HTML |
| [reports/](reports/) | 최종 결과 문서와 4주간 학습 정리 |
| [.github/workflows/](.github/workflows/) | 테스트·빌드·배포 자동화 |

SQL을 살펴볼 때는 `sql/README.md`, 웹 결과물을 살펴볼 때는 `web/README.md`에서 시작한다. 전체 성과와 학습 내용은 `reports/`에서 확인할 수 있다.

## 출처

- [강의 자료](https://app.notion.com/p/40163fd59006804f94a9eb6b49e8785a)
- [건강보험 청구 데이터](https://docs.google.com/spreadsheets/d/1nPuY8AKFAs2r9da4xUBV3WMKdLEBZJGpmd3kP7xKNvU)
- [SQL 원본 자료](https://drive.google.com/drive/folders/1zM91ATIR5OSxSAlfF442GDovxkQ8f7tP)
- [구성과 결과 비교에 참고한 저장소](https://github.com/jihyeongh21-svg/nano-dree-sql)
