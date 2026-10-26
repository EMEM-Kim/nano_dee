# AI 헬스케어 데이터 분석 · CareLens

건강보험 청구 데이터와 폐암 합성 데이터를 SQL로 분석하고, 청구 현황을 **CareLens 웹 대시보드**로 시각화한 강의 실습·과제 프로젝트이다. 데이터 조회와 집계에서 출발해 지표 정의, 차트 구현, 결과 검증, GitHub Pages 배포까지 진행했다.

[대시보드 보기](https://emem-kim.github.io/nano_dee/dashboard.html) · [호흡기 질환 그래프 보기](https://emem-kim.github.io/nano_dee/graph.html) · [강의 회고](docs/reflection.md)

## 프로젝트 목적

병원 경영기획 담당자가 월초 경영회의 전에 **청구 규모, 주요 상병, 계절별 진료 수요**를 확인하는 상황을 설정했다. 명세서 수와 수진자 수를 구분하고, 비교 목적에 맞는 지표와 차트를 구성했다.

SQL에서는 조건별 조회, 여러 테이블의 연결, 그룹별 집계, 방문 간격 계산과 코호트 분석을 수행했다. 웹에서는 같은 청구 데이터를 필터로 탐색하고 집계 결과를 CSV로 내려받을 수 있도록 구현했다.

## 데이터와 분석 범위

| 데이터 | 범위 | 주요 활용 |
|---|---|---|
| 건강보험 청구 `kr_claims` | 2024~2025년 명세서 38,375건 | 상병·기관 종별 분석, 월별 추세, 대시보드 |
| 폐암 합성 데이터 `kr_lung_cancer` | 환자 9,897명 | 진단 시점별 코호트, 병기별 치료·사망 기록 분석 |

두 데이터 모두 **수업용 가상·합성 데이터**이다. 분석 결과는 해당 데이터 내 관찰이며 실제 환자 기록이나 전국 통계를 의미하지 않는다.

## 사용 기술

| 구분 | 기술 | 사용 목적 |
|---|---|---|
| SQL 분석 | MySQL 8.4 | JOIN, GROUP BY, CTE, CASE, 윈도우 함수를 활용한 집계 |
| 데이터 전처리 | Python, openpyxl | XLSX 읽기, 기관·상병 코드 연결, 독립 집계 |
| 웹 화면 | HTML, CSS, JavaScript | KPI, 필터, 반응형 화면, CSV 다운로드 |
| 차트 | SVG | 막대그래프와 꺾은선 그래프 구현 |
| 빌드·검증 | Node.js | 단독 실행 HTML 생성, 집계 로직 검사 |
| 배포 | GitHub Actions, GitHub Pages | 테스트·빌드 및 정적 사이트 배포 |

## 실습·과제 구성

| 구분 | 수행 내용 | 결과물 |
|---|---|---|
| SQL 실습 1~5 | 명세서 조회, 종별 집계, 방문 간격, 폐암 코호트, 병기별 치료 | [실습 SQL](sql/practice/practice_1-5.sql) |
| SQL 과제 1 | 2025년 7월 외래와 전체 기간 입원 명세서 분석 | [과제 1 SQL](sql/assignments/assignment_1.sql) |
| SQL 과제 2 | 2024년 외래 상병별 집계와 당뇨병 방문 간격 | [과제 2 SQL](sql/assignments/assignment_2.sql) |
| SQL 과제 3 | 병기별 3년 내 기록된 사망 비율 | [과제 3 SQL](sql/assignments/assignment_3.sql) |
| 웹 1일차 | 호흡기 질환 청구의 월별 변화 시각화 | [graph.html](graph.html) |
| 웹 2일차 | KPI·차트·필터를 갖춘 청구 현황 대시보드 | [dashboard.html](dashboard.html) |
| 웹 3일차 | GitHub Pages 배포와 학습 회고 | [배포 문서](docs/deployment.md), [회고](docs/reflection.md) |

## 주요 분석 결과

### 청구 데이터

| 지표 | 전체 기간 결과 | 계산 기준 |
|---|---:|---|
| 명세서 수 | 38,375건 | 청구 행 수 |
| 총 진료비 | 3,293,580,300원 | `rvd_rpe_tamt_amt` 합계 |
| 수진자 수 | 2,970명 | `jid` 중복 제거 |

- 주상병 중 급성 기관지염(J209)이 **5,285건**으로 가장 많았다.
- 호흡기 질환 청구의 11~3월 월평균은 **742.1건**, 6~9월은 **341.875건**으로 약 **2.17배** 차이가 났다. 비교 기간의 길이가 달라 총합 대신 월평균을 사용했다.
- 기관 종별 건당 진료비는 상급종합병원 약 **499,558원**, 의원 약 **36,019원**이었다. 중증도와 입원 비중을 보정하지 않은 평균이므로 진료의 질이나 효율을 뜻하지 않는다.

### SQL 과제

- **과제 1:** 2025년 7월 외래 명세서는 1,450건이었다. 해당 조건의 진료비 1위 명세서는 3,182,000원이었다.
- **과제 2:** 2024년 외래에서 500건 이상인 상병은 7개였다. 전체 기간 E119 외래에서 이전 방문과 90일을 초과한 방문은 1건으로, 간격은 94일이었다.
- **과제 3:** 2010~2017년 최초 진단 환자 6,873명을 분석했다. 초기 0~2기의 3년 내 기록된 사망 비율은 13.0%, 3기는 48.7%, 4기는 63.8%였다. 추적 누락을 고려하지 않은 값이므로 이를 바로 생존율로 변환할 수는 없다.

세부 결과와 해석은 [SQL 정리](docs/sql.md), 실행 출력은 [results.txt](sql/results/results.txt)에 기록했다.

## 대시보드 기능

| 기능 | 내용 |
|---|---|
| KPI 카드 | 명세서 수, 총 진료비, 고유 수진자 수 |
| 상병 비교 | 주상병별 명세서 수 TOP 8 가로 막대그래프 |
| 기관 비교 | 기관 종별 건당 진료비 가로 막대그래프 |
| 월별 추세 | 호흡기 질환(J코드) 명세서 수 꺾은선 그래프 |
| 조건 필터 | 연도·기관 종별·전체/호흡기 범위를 모든 KPI와 차트에 적용 |
| 결과 확인 | 월별 집계표, UTF-8 BOM CSV 다운로드, 필터 초기화 |

필터가 바뀌면 수진자 수를 다시 중복 제거해 계산한다. CSS·JavaScript·데이터를 HTML에 포함해 브라우저에서 오프라인으로도 실행할 수 있다. 현재 데이터 제공 방식은 정적 스냅샷이다.

## 파일 구성

| 위치 | 역할 |
|---|---|
| `index.html` | 기본 주소에서 대시보드로 이동 |
| `dashboard.html`, `graph.html` | 바로 열 수 있는 최종 HTML 결과물 |
| `sql/practice/` | SQL 실습 1~5 |
| `sql/assignments/` | SQL 과제 1~3 |
| `sql/results/` | MySQL 실행 결과 |
| `web/src/` | 화면 템플릿, 스타일, 집계 로직, 가공 데이터 |
| `web/prepare_data.py`, `web/requirements.txt` | 원본 XLSX 전처리와 Python 의존성 |
| `web/analysis.json` | 원자료의 독립 집계 결과 |
| `web/build.mjs`, `web/test.mjs` | HTML 빌드와 지표 검증 |
| `docs/` | SQL·웹 설명, 재현 프롬프트, 배포, 회고 |
| `.github/workflows/pages.yml` | GitHub Actions 검사·배포 설정 |

웹 수정은 `web/src/`에서 진행하고 빌드로 루트 HTML에 반영한다. 빌드 시 생성되는 `_site/`는 배포용 폴더이며 Git 추적 대상에서 제외했다.

## 실행 방법

### 결과물 확인

위의 공개 링크에 접속하거나 저장소를 내려받아 `dashboard.html` 또는 `graph.html`을 브라우저로 연다. 결과물 확인에는 별도 서버나 패키지 설치가 필요하지 않다.

### 웹 검증·빌드

Node.js 22 이상에서 저장소 루트를 기준으로 실행한다.

```sh
node web/test.mjs
node web/build.mjs
```

원자료를 다시 가공하려면 강의 XLSX를 `data/kr_claims.xlsx`에 저장한 뒤 실행한다.

```sh
python -m pip install -r web/requirements.txt
python web/prepare_data.py
node web/test.mjs
node web/build.mjs
```

### SQL 실행

MySQL 8.4에 강의 원본 SQL을 `01_setup.sql → 02_claim.sql → 03_sick_master.sql → 04_lung.sql` 순서로 적재한 뒤 실습·과제 SQL을 실행한다. `01_setup.sql`은 같은 이름의 데이터베이스를 초기화하므로 별도 실습 DB에서 실행한다. 원본 자료와 상세 절차는 [SQL 실행 안내](docs/sql.md)에 정리했다.

## 검증과 배포

전체 데이터와 2025년·의원 필터에 대해 명세서 수, 총 진료비, 고유 수진자 수를 검사했다. 월별 집계가 24개월인지도 확인했다.

| 검사 범위 | 명세서 수 | 총 진료비 | 수진자 수 |
|---|---:|---:|---:|
| 전체 | 38,375건 | 3,293,580,300원 | 2,970명 |
| 2025년·의원 | 15,374건 | 544,714,500원 | 2,705명 |

main에 push하면 GitHub Actions에서 테스트·빌드를 실행한다. 실제 Pages 배포는 **Actions → Dashboard checks and deployment → Run workflow**로 실행한다.

## 상세 문서

- [SQL 학습 내용과 과제 결과](docs/sql.md)
- [웹 구현과 지표 정의](docs/web.md)
- [웹 과제 정리와 재현 프롬프트](docs/submission.md)
- [GitHub Pages 배포 절차](docs/deployment.md)
- [강의 회고와 적용 아이디어](docs/reflection.md)

## 출처

- [강의 자료](https://app.notion.com/p/40163fd59006804f94a9eb6b49e8785a)
- [청구 데이터](https://docs.google.com/spreadsheets/d/1nPuY8AKFAs2r9da4xUBV3WMKdLEBZJGpmd3kP7xKNvU)
- [SQL 원본 자료](https://drive.google.com/drive/folders/1zM91ATIR5OSxSAlfF442GDovxkQ8f7tP)
- [구성과 결과 비교에 참고한 저장소](https://github.com/jihyeongh21-svg/nano-dree-sql)
