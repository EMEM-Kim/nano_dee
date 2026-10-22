-- PostgreSQL / Supabase SQL Editor. 교육용 합성 데이터 전용.
CREATE TABLE IF NOT EXISTS public.dashboard_claims (
 id bigint PRIMARY KEY,
 month text NOT NULL CHECK (month ~ '^20[0-9]{2}-(0[1-9]|1[0-2])$'),
 patient text NOT NULL,
 type text NOT NULL,
 disease text NOT NULL,
 cost bigint NOT NULL CHECK(cost>=0),
 form text NOT NULL,
 type_name text NOT NULL,
 disease_name text NOT NULL
);
ALTER TABLE public.dashboard_claims ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON public.dashboard_claims FROM anon, authenticated;
GRANT SELECT ON public.dashboard_claims TO anon, authenticated;
DROP POLICY IF EXISTS course_read ON public.dashboard_claims;
CREATE POLICY course_read ON public.dashboard_claims FOR SELECT TO anon, authenticated USING (true);
-- 쓰기 정책 없음. 브라우저 키는 읽기만 가능. 관리자 CSV import는 SQL Editor/Table Editor에서.
