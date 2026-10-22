# CareLens — 웹 대시보드 과제

노션 **5. 웹 대시보드 과제 1~3일차** 제출물입니다. SQL 과제는 이 작업에 포함하지 않았습니다.

| 제출일차 | 결과물 | 제출 방법 |
|---|---|---|
| 1일차 | [호흡기 질환 월별 그래프](web/dist/graph.html) | HTML 파일 첨부 + [작업 내용·재현 프롬프트](docs/submission.md) |
| 2일차 | [CareLens 대시보드](web/dist/dashboard.html) | 공개 URL + 결과 정리 + 재현 프롬프트 |
| 3일차 | 동일 대시보드 + [회고 노트](docs/reflection.md) | 공개 URL + A4 1장 이내 회고 |

**공개 예정 주소:** https://EMEM-Kim.github.io/nano_dee/dashboard.html

GitHub Pages 설정 및 배포 성공 확인이 필요합니다. [배포 안내](docs/deployment.md)를 참고하세요. 파일 업로드와 공개 배포는 별개이며, 현재 URL 접속 성공을 주장하지 않습니다.

## 대시보드 구성

병원 경영기획 담당자가 월초에 청구 규모·상병 구성·계절 수요를 살펴보는 화면입니다.

- KPI: 명세서 **38,375건**, 총 진료비 **3,293,580,300원**, 고유 수진자 **2,970명**
- 차트: 주상병 TOP 8, 기관 종별 건당 진료비, 월별 호흡기 질환 청구 추세
- 기능: 연도·기관 종별·상병 범위 필터, 초기화, 월별 표, CSV 내보내기
- 인사이트: J209가 5,285건으로 가장 많고, 호흡기 청구의 11~3월 월평균은 6~9월의 약 2.17배

모두 수업용 가상 데이터의 집계입니다. 실제 환자 기록·전국 발생률·의료기관 평가를 의미하지 않습니다.

## 기술 스택

| 기술 | 사용 목적 |
|---|---|
| HTML5 / CSS3 | 한국어 화면, 반응형 레이아웃, 단독 HTML 제출 파일 |
| JavaScript / SVG | 필터별 재집계, 접근성 레이블을 가진 차트, CSV 다운로드 |
| Python / openpyxl | 원본 XLSX 읽기, 조인 검증, 독립 집계 |
| Node.js | HTML 빌드, 데이터·필터·연결 코드 검증 |
| GitHub Pages / Actions | 정적 사이트 배포 구성 |
| Supabase / PostgreSQL | 선택 확장: 공개 합성 데이터 읽기 정책과 연결 코드. 실제 클라우드 연결 미검증 |
| ChatGPT Codex | 구현·문서 작성 보조. Claude Code를 사용했다고 표기하지 않음 |

## 실행·재현

다운로드한 `web/dist/dashboard.html`이나 `web/dist/graph.html`을 브라우저에서 열면 인터넷 없이 볼 수 있습니다. Node.js 22 이상에서 다음 명령으로 검증하고 빌드합니다.

```sh
node scripts/test_web.mjs
node web/build.mjs
```

원자료를 다시 반영하려면 강의 XLSX를 `data/kr_claims.xlsx`에 저장한 뒤 실행합니다.

```sh
python -m pip install -r requirements.txt
python web/prepare_data.py
node web/build.mjs
node scripts/test_web.mjs
```

검산 기준은 제공된 원본 스냅샷입니다. 원본이 변경되면 차이를 검토한 후 기준값도 갱신합니다.

## 정리 문서

- [제출란별 답안·작업 내용·재현 프롬프트](docs/submission.md)
- [학습 정리 및 구현 결정](docs/learning-notes.md)
- [회고 초안](docs/reflection.md)
- [실행 검증과 남은 단계](docs/verification.md)
- [GitHub Pages 배포](docs/deployment.md)
- [선택: Supabase 연결](docs/supabase.md)

## 출처

- [강의·과제 노션](https://app.notion.com/p/40163fd59006804f94a9eb6b49e8785a)
- [수업용 kr_claims 원자료](https://docs.google.com/spreadsheets/d/1nPuY8AKFAs2r9da4xUBV3WMKdLEBZJGpmd3kP7xKNvU)
- [참고 저장소](https://github.com/jihyeongh21-svg/nano-dree-sql): 정리 방식만 참고

폼 제출은 수행하지 않았습니다. 회고의 개인 경험·진로 관련 표현은 본인이 검토한 뒤 제출합니다.
