# 선택 확장 — Supabase 연결

1~3일차 기본 제출물은 `dashboard.html`입니다. 이 문서는 강의의 데이터베이스 연결 방식을 추가로 실습하려는 경우 사용합니다. **실제 Supabase 프로젝트에 연결한 결과는 아직 검증하지 않았습니다.**

1. 본인의 Supabase 프로젝트 SQL Editor에서 `supabase/schema.sql`을 실행합니다. 공개 합성 데이터 전용 테이블이 만들어집니다.
2. 저장소에서 `node scripts/export_supabase.mjs`를 실행해 `data/dashboard_claims.csv`를 생성합니다.
3. Table Editor에서 해당 CSV를 `dashboard_claims` 테이블에 가져옵니다. 총 38,375행인지 확인합니다.
4. `web/dist/config.js`에 프로젝트 URL과 공개 publishable key 또는 legacy anon key를 입력합니다. service_role·secret key·DB 비밀번호는 입력하지 않습니다.
5. HTTP 서버 또는 Pages의 `live.html`을 엽니다. 조회 완료 상태와 건수·KPI를 확인합니다.
6. 테스트 행의 금액을 수정하고 새로고침하여 합계가 변경된 만큼 바뀌는지 확인한 뒤 원래 값으로 복구합니다.

브라우저는 1,000행씩 요청하며 서버 제한이 더 작아도 빈 페이지까지 읽습니다. `id` 정렬로 페이지 순서를 고정합니다. 조회 중 데이터가 동시에 바뀌면 일관된 스냅샷을 보장하지 않으므로 대규모 운영 환경에서는 서버 측 집계·스냅샷 API로 확장해야 합니다.

RLS는 이 교육용 합성 데이터의 읽기만 허용하고 익명 쓰기는 허용하지 않습니다. 실제 의료·개인 데이터를 같은 공개 정책으로 넣으면 안 됩니다.

공식 참고: [Supabase RLS](https://supabase.com/docs/guides/database/postgres/row-level-security)
