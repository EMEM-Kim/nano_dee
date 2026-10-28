# 웹 대시보드 구현

병원 경영기획 담당자가 월초에 청구 규모·상병 구성·계절 수요를 확인하는 화면이다.

## 파일 역할

| 경로 | 역할 |
|---|---|
| `web/output/graph.html` | 1일차 제출용 단독 그래프 |
| `web/output/dashboard.html` | 2·3일차 대시보드, CSS·데이터·JS 포함 |
| `web/output/index.html` | 기본 주소에서 dashboard.html로 이동 |
| `web/src/index.template.html` | 화면 구조 |
| `web/src/styles.css` | 디자인·반응형 스타일 |
| `web/src/app.js` | 집계·필터·차트·CSV |
| `web/src/data.js` | 필요한 6개 필드로 가공한 가상 데이터 |
| `web/analysis.json` | 원자료의 독립 집계 |
| `web/prepare_data.py` | XLSX 추출·조인·검산 |
| `web/build.mjs` | 제출 HTML과 배포용 _site 생성 |
| `web/test.mjs` | 핵심 지표·필터 계산 검증 |

## 지표 정의

명세서 수는 행 수, 진료비는 rvd_rpe_tamt_amt 합계, 수진자는 고유 jid 수다. 월별 고유 수진자 수를 단순 합산하지 않는다. 기관별 건당 진료비는 총액/건수이며 중증도·입원 비중을 보정한 값은 아니다.

claim과 institution은 yid, 상병명은 main_sick와 sickcd로 연결했다. 기관 종별명은 code_table에서 code_type='종별코드'인 행을 사용한다.

주상병 TOP 8과 종별 평균 진료비는 가로 막대, 호흡기 질환 월별 추세는 꺾은선으로 표현했다. 기간 길이가 다른 11~3월과 6~9월은 총합 대신 월평균을 비교했다.

## 실행

브라우저로 `web/output/`의 HTML을 열면 오프라인에서도 실행된다. Node.js 22 이상에서 다음 명령을 실행한다.
```sh
node web/test.mjs
node web/build.mjs
```

원자료를 갱신하려면 강의 XLSX를 data/kr_claims.xlsx에 저장한 뒤 다음 명령을 실행한다.
```sh
python -m pip install -r web/requirements.txt
python web/prepare_data.py
node web/build.mjs
node web/test.mjs
```
검산값은 제공된 스냅샷 기준이므로 원자료 변경 시 차이를 검토해야 한다.

## 검증 결과

| 범위 | 명세서 | 진료비 | 수진자 |
|---|---:|---:|---:|
| 전체 | 38,375 | 3,293,580,300원 | 2,970 |
| 2025년·의원 | 15,374 | 544,714,500원 | 2,705 |

월별 호흡기 청구는 24개월이며, 겨울철 월평균은 742.1건, 6~9월은 341.875건으로 약 2.17배다. 데스크톱 화면·필터·초기화를 확인했다. 모바일은 반응형 CSS를 구현했으며 실제 기기 검증은 하지 않았다.

데이터는 HTML에 포함한 정적 스냅샷으로 제공한다. 재현 명세는 [과제 정리](prompts.md), 배포 방식은 [배포 문서](deployment.md)에 정리했다.
