USE kr_claims;
-- Q1: 2025년 7월 외래 명세서. 월의 다음 시작일을 제외하는 범위 사용.
SELECT COUNT(*) AS july_outpatient_claims FROM claim
WHERE fom_tp_cd='031' AND recu_fr_dd>='2025-07-01' AND recu_fr_dd<'2025-08-01';
-- Q2: 비용 내림차순, 동률이면 명세서 번호순.
SELECT c.mid,c.recu_fr_dd,c.main_sick,s.krnm,c.rvd_rpe_tamt_amt
FROM claim c LEFT JOIN sick_master s ON s.sickcd=c.main_sick
WHERE c.fom_tp_cd='031' AND c.recu_fr_dd>='2025-07-01' AND c.recu_fr_dd<'2025-08-01'
ORDER BY c.rvd_rpe_tamt_amt DESC,c.mid LIMIT 10;
-- Q3: 전체 2년 입원, 방문일수(vst_ddcnt) 기준. 달력 날짜 차이와 다름.
SELECT c.mid,c.main_sick,s.krnm,c.vst_ddcnt,c.recu_fr_dd,c.recu_to_dd
FROM claim c LEFT JOIN sick_master s ON s.sickcd=c.main_sick
WHERE c.fom_tp_cd='021'
ORDER BY c.vst_ddcnt DESC,c.mid LIMIT 10;
-- Q4 서술형 답안: docs/sql.md
