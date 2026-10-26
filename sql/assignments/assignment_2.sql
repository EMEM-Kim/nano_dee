USE kr_claims;
-- Q1: 메인 과제 페이지의 2024년 조건 적용(일별 자료의 2025년과 구분).
SELECT c.main_sick,s.krnm,COUNT(*) AS claims,COUNT(DISTINCT c.jid) AS patients,
       ROUND(COUNT(*)/COUNT(DISTINCT c.jid),2) AS claims_per_patient
FROM claim c LEFT JOIN sick_master s ON s.sickcd=c.main_sick
WHERE c.fom_tp_cd='031' AND c.recu_fr_dd>='2024-01-01' AND c.recu_fr_dd<'2025-01-01'
GROUP BY c.main_sick,s.krnm ORDER BY claims DESC,c.main_sick LIMIT 5;
-- Q2: 행이 아니라 그룹에 조건 적용.
SELECT c.main_sick,s.krnm,COUNT(*) AS claims,COUNT(DISTINCT c.jid) AS patients,
       ROUND(COUNT(*)/COUNT(DISTINCT c.jid),2) AS claims_per_patient
FROM claim c LEFT JOIN sick_master s ON s.sickcd=c.main_sick
WHERE c.fom_tp_cd='031' AND c.recu_fr_dd>='2024-01-01' AND c.recu_fr_dd<'2025-01-01'
GROUP BY c.main_sick,s.krnm HAVING COUNT(*)>=500 ORDER BY claims DESC,c.main_sick;
-- Q3: 전체 기간 E119 외래. 같은 날 방문은 mid로 순서를 고정.
WITH visits AS (
 SELECT mid,jid,recu_fr_dd,
 ROW_NUMBER() OVER(PARTITION BY jid ORDER BY recu_fr_dd,mid) AS visit_no,
 DATEDIFF(recu_fr_dd,LAG(recu_fr_dd) OVER(PARTITION BY jid ORDER BY recu_fr_dd,mid)) AS gap_days,
 SUM(rvd_rpe_tamt_amt) OVER(PARTITION BY jid ORDER BY recu_fr_dd,mid ROWS UNBOUNDED PRECEDING) AS cumulative_cost
 FROM claim WHERE main_sick='E119' AND fom_tp_cd='031'
)
SELECT * FROM visits WHERE gap_days>90 ORDER BY gap_days DESC,jid,mid;
