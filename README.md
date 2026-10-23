# AI 헬스케어 데이터 분석
SQL로 건강보험 청구·폐암 합성 데이터를 분석하고, 청구 현황을 웹 대시보드로 시각화한 강의 실습·과제 저장소입니다.

## 사용 기술
- **SQL 분석:** MySQL 8.4 — JOIN, GROUP BY, 윈도우 함수, CTE, CASE
- **웹:** HTML, CSS, JavaScript, SVG
- **데이터 처리·검증:** Python, openpyxl, Node.js
- **배포:** GitHub Actions, GitHub Pages

## 실습·과제
| 구분 | 내용 | 파일 |
|---|---|---|
| SQL 실습 1~5 | 명세서 조회, 종별 집계, 방문 간격, 폐암 코호트, 병기별 치료 | [practice_1-5.sql](sql/practice_1-5.sql) |
| SQL 과제 1 | 2025년 7월 외래·입원 명세서 분석 | [assignment_1.sql](sql/assignment_1.sql) |
| SQL 과제 2 | 2024년 상병별 집계·당뇨병 방문 간격 | [assignment_2.sql](sql/assignment_2.sql) |
| SQL 과제 3 | 병기별 3년 내 기록된 사망 비율 | [assignment_3.sql](sql/assignment_3.sql) |
| 웹 1일차 | 월별 호흡기 질환 청구 그래프 | [graph.html](graph.html) |
| 웹 2·3일차 | 청구 현황 대시보드·회고 | [dashboard.html](dashboard.html), [회고](docs/reflection.md) |

## 주요 결과
청구 **38,375건**, 총 진료비 **3,293,580,300원**, 수진자 **2,970명**을 확인했습니다. 대시보드에서 연도·기관 종별·상병 범위를 선택하면 KPI와 차트가 함께 바뀝니다.

데이터는 수업용 가상·합성 데이터이며 실제 환자 기록이나 전국 통계가 아닙니다.

## 문서
- [SQL 학습 내용·과제 결과·실행 방법](docs/sql.md)
- [웹 구현·파일 구조·검증](docs/web.md)
- [웹 제출용 답안·재현 프롬프트](docs/submission.md)
- [GitHub Pages 배포](docs/deployment.md) — 현재 공개 배포 설정 필요

## 출처
[강의 노션](https://app.notion.com/p/40163fd59006804f94a9eb6b49e8785a) · [청구 데이터](https://docs.google.com/spreadsheets/d/1nPuY8AKFAs2r9da4xUBV3WMKdLEBZJGpmd3kP7xKNvU) · [구성 참고 저장소](https://github.com/jihyeongh21-svg/nano-dree-sql)
