-- 실습 1
USE kr_claims;
-- SELECT / WHERE / ORDER BY / JOIN: 12월 외래 비용 상위 10건 + 기관 종별 심화.
SELECT COUNT(*) AS december_outpatient_claims FROM claim
WHERE fom_tp_cd='031' AND recu_fr_dd>='2025-12-01' AND recu_fr_dd<'2026-01-01';
SELECT c.mid,c.recu_fr_dd,c.main_sick,s.krnm,t.code_nm AS institution_type,c.rvd_rpe_tamt_amt
FROM claim c LEFT JOIN sick_master s ON s.sickcd=c.main_sick
LEFT JOIN institution i ON i.yid=c.yid
LEFT JOIN code_table t ON t.code_type='종별코드' AND t.code=i.cl_cd
WHERE c.fom_tp_cd='031' AND c.recu_fr_dd>='2025-12-01' AND c.recu_fr_dd<'2026-01-01'
ORDER BY c.rvd_rpe_tamt_amt DESC,c.mid LIMIT 10;
-- 심화: 한 환자의 시간순 진료 이력.
SELECT mid,recu_fr_dd,fom_tp_cd,main_sick,rvd_rpe_tamt_amt
FROM claim WHERE jid=100001 ORDER BY recu_fr_dd,mid;


-- 실습 2
USE kr_claims;
-- 합계의 비율: 명세서별 비율의 단순 평균과 다르다.
SELECT t.code_nm AS institution_type,COUNT(*) AS claims,
 ROUND(AVG(c.rvd_rpe_tamt_amt)) AS average_cost,
 ROUND(100*SUM(c.rvd_slf_brdn_amt)/NULLIF(SUM(c.rvd_rpe_tamt_amt),0),1) AS self_pct
FROM claim c JOIN institution i ON i.yid=c.yid
JOIN code_table t ON t.code_type='종별코드' AND t.code=i.cl_cd
GROUP BY t.code_nm ORDER BY average_cost DESC;
-- HAVING: 3,000건 이상 그룹만.
SELECT i.cl_cd,COUNT(*) AS claims,ROUND(AVG(c.rvd_rpe_tamt_amt)) AS average_cost
FROM claim c JOIN institution i ON i.yid=c.yid
GROUP BY i.cl_cd HAVING COUNT(*)>=3000 ORDER BY average_cost DESC;
-- 심화1: 종별과 입원/외래 조합.
SELECT t.code_nm AS institution_type,f.code_nm AS form,COUNT(*) AS claims,
ROUND(AVG(c.rvd_rpe_tamt_amt)) AS average_cost,
ROUND(100*SUM(c.rvd_slf_brdn_amt)/NULLIF(SUM(c.rvd_rpe_tamt_amt),0),1) AS self_pct
FROM claim c JOIN institution i ON i.yid=c.yid
JOIN code_table t ON t.code_type='종별코드' AND t.code=i.cl_cd
JOIN code_table f ON f.code_type='서식구분코드' AND f.code=c.fom_tp_cd
GROUP BY t.code_nm,f.code_nm ORDER BY average_cost DESC;
-- 심화2: 2025년 외래 상위 10개 상병.
SELECT c.main_sick,s.krnm,COUNT(*) AS claims,COUNT(DISTINCT jid) AS patients
FROM claim c LEFT JOIN sick_master s ON s.sickcd=c.main_sick
WHERE fom_tp_cd='031' AND recu_fr_dd>='2025-01-01' AND recu_fr_dd<'2026-01-01'
GROUP BY c.main_sick,s.krnm ORDER BY claims DESC,c.main_sick LIMIT 10;


-- 실습 3
USE kr_claims;
CREATE OR REPLACE VIEW hypertension_visits AS
SELECT mid,jid,recu_fr_dd,ROW_NUMBER() OVER(PARTITION BY jid ORDER BY recu_fr_dd,mid) AS visit_no,
DATEDIFF(recu_fr_dd,LAG(recu_fr_dd) OVER(PARTITION BY jid ORDER BY recu_fr_dd,mid)) AS gap_days,
SUM(rvd_rpe_tamt_amt) OVER(PARTITION BY jid ORDER BY recu_fr_dd,mid ROWS UNBOUNDED PRECEDING) AS cumulative_cost
FROM claim WHERE main_sick='I109' AND fom_tp_cd='031';
SELECT COUNT(*) AS claims,COUNT(DISTINCT jid) AS patients,ROUND(AVG(gap_days),1) AS average_gap FROM hypertension_visits;
SELECT * FROM hypertension_visits WHERE gap_days>90 ORDER BY gap_days DESC,jid,mid;
-- LAG로 잡히지 않는 마지막 방문 이후의 미복귀.
SELECT COUNT(*) AS not_returned FROM (
 SELECT jid,MAX(recu_fr_dd) AS last_visit FROM hypertension_visits GROUP BY jid
) p WHERE DATEDIFF('2025-12-31',last_visit)>90;
-- 심화: 3회 이상 내원자의 평균 간격 상위 10명.
SELECT jid,COUNT(*) AS visits,ROUND(AVG(gap_days),1) AS average_gap
FROM hypertension_visits GROUP BY jid HAVING COUNT(*)>=3 ORDER BY average_gap DESC,jid LIMIT 10;
-- 심화: 당뇨병으로 조건 변경한 결과는 sql/assignments/assignment_2.sql Q3.


-- 실습 4
USE kr_lung_cancer;
CREATE OR REPLACE VIEW cohort_2010_2019 AS
SELECT pt_sbst_no,bspt_frst_diag_ymd AS index_date,YEAR(bspt_frst_diag_ymd) AS diagnosis_year,bspt_stag_vl
FROM lung_pt_bsnf WHERE bspt_frst_diag_ymd>='2010-01-01' AND bspt_frst_diag_ymd<'2020-01-01';
-- CTE로 대상과 결과 정의를 분리. 사망 기록 없는 사람도 분모에 유지.
WITH outcomes AS (
 SELECT c.*,CASE WHEN DATEDIFF(d.dead_ymd,c.index_date) BETWEEN 0 AND 365 THEN 1 ELSE 0 END AS dead_1y
 FROM cohort_2010_2019 c LEFT JOIN lung_dead_nfrm d ON d.pt_sbst_no=c.pt_sbst_no
)
SELECT diagnosis_year,COUNT(*) AS patients,SUM(dead_1y) AS recorded_deaths,ROUND(100*AVG(dead_1y),1) AS death_pct
FROM outcomes GROUP BY diagnosis_year ORDER BY diagnosis_year;
-- JOIN 종류에 따른 분모 차이를 수치로 확인(오류 비교 실습).
SELECT COUNT(*) AS full_cohort,COUNT(d.pt_sbst_no) AS inner_join_denominator
FROM cohort_2010_2019 c LEFT JOIN lung_dead_nfrm d ON d.pt_sbst_no=c.pt_sbst_no;
-- 심화1: 병기별 1년 내 기록된 사망.
SELECT c.bspt_stag_vl,COUNT(*) AS patients,
SUM(CASE WHEN DATEDIFF(d.dead_ymd,c.index_date) BETWEEN 0 AND 365 THEN 1 ELSE 0 END) AS deaths_1y
FROM cohort_2010_2019 c LEFT JOIN lung_dead_nfrm d ON d.pt_sbst_no=c.pt_sbst_no
GROUP BY c.bspt_stag_vl ORDER BY c.bspt_stag_vl;
-- 심화2: 원본의 음수 생존일수 대신 날짜에서 다시 계산.
SELECT pt_sbst_no,bspt_frst_diag_ymd,bspt_dead_ymd,ovrl_srvl_dtrn_dcnt,
DATEDIFF(bspt_dead_ymd,bspt_frst_diag_ymd) AS recalculated_days
FROM lung_pt_bsnf WHERE bspt_dead_ymd IS NOT NULL ORDER BY pt_sbst_no LIMIT 5;
-- 심화3: 일대다 테이블은 먼저 환자당 한 행으로 만든다.
WITH operations AS (
 SELECT pt_sbst_no,MIN(oprt_ymd) AS first_operation FROM lung_oprt_nfrm GROUP BY pt_sbst_no
), adjuvant AS (
 SELECT pt_sbst_no,MIN(cstr_strt_ymd) AS first_adjuvant FROM lung_trtm_casb
 WHERE cstr_prps_nm='Adjuvant' GROUP BY pt_sbst_no
)
SELECT COUNT(*) AS patients,ROUND(AVG(DATEDIFF(a.first_adjuvant,o.first_operation)),1) AS average_days,
SUM(a.first_adjuvant<o.first_operation) AS before_operation
FROM operations o JOIN adjuvant a ON a.pt_sbst_no=o.pt_sbst_no;


-- 실습 5
USE kr_lung_cancer;
CREATE OR REPLACE VIEW patients_with_stage AS
SELECT p.*,CASE WHEN bspt_stag_vl IN ('0','1','2') THEN '1) 초기 (0~2기)'
 WHEN bspt_stag_vl='3' THEN '2) 국소 진행 (3기)'
 WHEN bspt_stag_vl='4' THEN '3) 전이 (4기)' ELSE '4) 병기 미상' END AS stage_group
FROM lung_pt_bsnf p;
SELECT stage_group,COUNT(*) AS patients,
ROUND(100*AVG(bspt_frst_oprt_ymd IS NOT NULL),1) AS surgery_pct,
ROUND(100*AVG(bspt_frst_ancn_trtm_strt_ymd IS NOT NULL),1) AS chemo_pct,
ROUND(100*AVG(bspt_frst_rdt_strt_ymd IS NOT NULL),1) AS radiation_pct,
ROUND(100*AVG(bspt_dead_ymd IS NOT NULL),1) AS recorded_death_pct
FROM patients_with_stage GROUP BY stage_group ORDER BY stage_group;
-- 심화1: CASE 순서가 중요. 방사선 병행 여부를 이름에서 숨기지 않는다.
SELECT CASE WHEN bspt_frst_oprt_ymd IS NOT NULL AND bspt_frst_ancn_trtm_strt_ymd IS NOT NULL THEN '수술+항암 (방사선 무관)'
 WHEN bspt_frst_oprt_ymd IS NOT NULL THEN '수술, 항암 없음 (방사선 무관)'
 WHEN bspt_frst_ancn_trtm_strt_ymd IS NOT NULL THEN '항암, 수술 없음 (방사선 무관)'
 WHEN bspt_frst_rdt_strt_ymd IS NOT NULL THEN '방사선만' ELSE '치료 기록 없음' END AS treatment_path,
COUNT(*) AS patients FROM lung_pt_bsnf GROUP BY treatment_path ORDER BY patients DESC;
-- 심화2: NULL 나이는 75세 이상에 섞지 않는다.
SELECT CASE WHEN bspt_idgn_age IS NULL THEN '5) 미상' WHEN bspt_idgn_age<50 THEN '1) 50세 미만'
WHEN bspt_idgn_age<65 THEN '2) 50~64세' WHEN bspt_idgn_age<75 THEN '3) 65~74세' ELSE '4) 75세 이상' END AS age_group,
COUNT(*) AS patients,ROUND(100*AVG(bspt_frst_oprt_ymd IS NOT NULL),1) AS surgery_pct
FROM lung_pt_bsnf GROUP BY age_group ORDER BY age_group;
-- 심화3: 병기 그룹별 1년 결과. 기간은 실습4의 2010~2019년.
WITH outcomes AS (
 SELECT p.stage_group,CASE WHEN DATEDIFF(d.dead_ymd,p.bspt_frst_diag_ymd) BETWEEN 0 AND 365 THEN 1 ELSE 0 END AS dead_1y
 FROM patients_with_stage p LEFT JOIN lung_dead_nfrm d ON d.pt_sbst_no=p.pt_sbst_no
 WHERE p.bspt_frst_diag_ymd>='2010-01-01' AND p.bspt_frst_diag_ymd<'2020-01-01'
)
SELECT stage_group,COUNT(*) AS patients,SUM(dead_1y) AS recorded_deaths,ROUND(100*AVG(dead_1y),1) AS death_pct
FROM outcomes GROUP BY stage_group ORDER BY stage_group;
