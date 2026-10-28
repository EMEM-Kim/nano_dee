# SQL 실습 프로젝트

## 1. 프로젝트 소개

건강보험 청구 데이터 `kr_claims`와 폐암 합성 데이터 `kr_lung_cancer`를 활용한 SQL 학습 프로젝트이다. WEEK 1의 조회·집계 학습과 WEEK 2의 심화 실습·과제 보완 결과를 정리했다. 청구 데이터는 2024~2025년 38,375건, 폐암 데이터는 환자 9,897명으로 구성된 수업용 가상·합성 데이터이다.

## 2. 사용 기술

- SQL, MySQL 8.4.11
- JOIN, GROUP BY, HAVING, CASE, CTE
- LAG, ROW_NUMBER, SUM 윈도우 함수

## 3. 주요 실습 내용

| 구분 | 수행 내용 | 파일 |
|---|---|---|
| 기본·심화 실습 1~5 | 조건 조회, 종별 집계, 방문 간격, 폐암 코호트, 병기별 치료 | [실습 SQL](practice/practice_1-5.sql) |
| 과제 1 | 2025년 7월 외래와 전체 기간 입원 분석 | [과제 1](assignments/assignment_1.sql) |
| 과제 2 | 2024년 외래 상병 집계, 당뇨병 재방문 간격 | [과제 2](assignments/assignment_2.sql) |
| 과제 3 | 최초 진단 시점과 병기에 따른 3년 내 사망 기록 | [과제 3](assignments/assignment_3.sql) |

추가·심화 실습에서는 단순 조회를 넘어 이전 방문과의 간격, 누적 진료비, 병기별 치료 비율을 계산했다. 기존 과제는 연도 조건, 동일 날짜의 정렬 기준, 미상 병기와 추적 누락의 처리 기준을 보완했다.

## 4. 주요 SQL

당뇨병(E119) 외래 명세서에서 이전 방문 후 90일이 지나 다시 방문한 기록을 찾는 쿼리이다. [과제 2의 Q3](assignments/assignment_2.sql)에 작성했다.

```sql
WITH visits AS (
    SELECT mid, jid, recu_fr_dd,
           ROW_NUMBER() OVER (
               PARTITION BY jid ORDER BY recu_fr_dd, mid
           ) AS visit_no,
           DATEDIFF(
               recu_fr_dd,
               LAG(recu_fr_dd) OVER (
                   PARTITION BY jid ORDER BY recu_fr_dd, mid
               )
           ) AS gap_days,
           SUM(rvd_rpe_tamt_amt) OVER (
               PARTITION BY jid ORDER BY recu_fr_dd, mid
               ROWS UNBOUNDED PRECEDING
           ) AS cumulative_cost
    FROM claim
    WHERE main_sick = 'E119' AND fom_tp_cd = '031'
)
SELECT *
FROM visits
WHERE gap_days > 90
ORDER BY gap_days DESC, jid, mid;
```

`PARTITION BY jid`로 환자별 방문을 구분하고 `LAG`로 직전 방문일을 가져왔다. 같은 날 여러 명세서가 있는 경우에도 순서가 일정하도록 `mid`를 추가했다. 방문 간격을 계산한 뒤 바깥 쿼리에서 90일 초과 조건을 적용했다.

## 5. 문제 해결

| 점검한 문제 | 해결 방법 |
|---|---|
| 과제의 2024년 조건과 심화 자료의 2025년 조건 혼동 | 과제 쿼리의 시작일·종료일을 명시했다. |
| 청구 건수와 환자 수의 혼동 | COUNT(*)와 COUNT(DISTINCT jid)를 구분했다. |
| 같은 날 방문의 순서 및 누적 합계 범위 | 날짜 다음에 mid로 정렬하고 ROWS를 명시했다. |
| 일대다 조인으로 인한 환자 중복 집계 | 치료 정보를 환자당 한 행으로 집계한 뒤 연결했다. |
| 사망 기록이 없는 환자의 추적 누락 | 마지막 방문일을 별도로 점검하고 단순 생존율 해석을 피했다. |

## 6. 결과

| 항목 | 결과 |
|---|---|
| 2025년 7월 외래 명세서 | 1,450건 |
| 해당 외래 조건의 최고 진료비 | 3,182,000원 |
| 2024년 외래에서 500건 이상인 상병 | 7개 |
| E119 외래의 90일 초과 재방문 | 1건, 94일 |
| 2010~2017년 최초 진단 폐암 코호트 | 6,873명 |
| 초기 0~2기 / 3기 / 4기의 3년 내 기록된 사망 비율 | 13.0% / 48.7% / 63.8% |

MySQL에서 실행한 [출력 원문](results/results.txt)과 [세부 해석](results/analysis.md)을 함께 정리했다. 사망 비율은 추적 누락과 검열을 보정한 생존 분석 결과가 아니다.

실행은 별도 실습용 MySQL에 강의 원본 SQL을 `01_setup.sql → 02_claim.sql → 03_sick_master.sql → 04_lung.sql` 순서로 적재한 뒤 진행한다. `01_setup.sql`은 같은 이름의 DB를 초기화한다. [원본 자료와 실행 안내](results/analysis.md)를 참고한다.

## 7. 배운 점

SQL은 결과 행을 얻는 것뿐 아니라 분석 대상과 집계 단위를 정확히 정하는 과정이다. WHERE는 집계 전 행을, HAVING은 집계된 그룹을 제한한다는 차이를 실습했다. 윈도우 함수를 사용하면 개별 방문 기록을 유지하면서 이전 방문과 누적 값을 함께 확인할 수 있었다.

환자 수를 셀 때는 조인으로 늘어난 행과 실제 환자를 구분해야 했다. 사망 기록이 없다는 이유만으로 생존했다고 판단할 수 없다는 점도 배웠다. 이러한 기준은 백엔드 통계 API와 대시보드의 지표를 설계할 때에도 적용할 수 있다.

## 8. GitHub

- [SQL 결과물](https://github.com/EMEM-Kim/nano_dee/tree/main/sql)
- [전체 프로젝트](../README.md)
- [4주간 학습 정리](../reports/learning-summary.md)
