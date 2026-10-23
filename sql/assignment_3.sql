USE kr_lung_cancer;
-- Q1: 최초 진단일 기준 코호트.
SELECT COUNT(*) AS cohort_patients FROM lung_pt_bsnf
WHERE bspt_frst_diag_ymd>='2010-01-01' AND bspt_frst_diag_ymd<'2018-01-01';
-- Q2: 3년을 과제 정의인 1095일로 계산. 미상 병기는 별도 그룹.
WITH cohort AS (
 SELECT pt_sbst_no,bspt_frst_diag_ymd AS diagnosis_date,
 CASE WHEN bspt_stag_vl IN ('0','1','2') THEN '1) 초기 (0~2기)'
 WHEN bspt_stag_vl='3' THEN '2) 국소 진행 (3기)'
 WHEN bspt_stag_vl='4' THEN '3) 전이 (4기)' ELSE '4) 병기 미상' END AS stage_group
 FROM lung_pt_bsnf WHERE bspt_frst_diag_ymd>='2010-01-01' AND bspt_frst_diag_ymd<'2018-01-01'
), outcomes AS (
 SELECT c.*,CASE WHEN DATEDIFF(d.dead_ymd,c.diagnosis_date) BETWEEN 0 AND 1095 THEN 1 ELSE 0 END AS dead_3y
 FROM cohort c LEFT JOIN lung_dead_nfrm d ON d.pt_sbst_no=c.pt_sbst_no
)
SELECT stage_group,COUNT(*) AS patients,SUM(dead_3y) AS recorded_deaths_3y,
ROUND(AVG(dead_3y)*100,1) AS recorded_death_pct_3y
FROM outcomes GROUP BY stage_group ORDER BY stage_group;
-- 추적 한계 점검: 사망 미기록이며 마지막 방문이 1095일보다 이전인 환자.
SELECT COUNT(*) AS incomplete_followup FROM lung_pt_bsnf p
LEFT JOIN lung_dead_nfrm d ON d.pt_sbst_no=p.pt_sbst_no
WHERE p.bspt_frst_diag_ymd>='2010-01-01' AND p.bspt_frst_diag_ymd<'2018-01-01'
AND d.dead_ymd IS NULL
AND (p.center_last_vst_ymd IS NULL OR DATEDIFF(p.center_last_vst_ymd,p.bspt_frst_diag_ymd)<1095);
