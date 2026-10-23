import fs from 'node:fs';
import path from 'node:path';
import {fileURLToPath} from 'node:url';
const root=path.dirname(fileURLToPath(import.meta.url));
const source=path.join(root,'src'),dist=path.join(root,'..'),read=n=>fs.readFileSync(path.join(source,n),'utf8');
// Prefer the course's institution category label over the legacy insurer label.
const data=read('data.js').replace('종합전문병원,상급종합병원','상급종합병원');

const css=read('styles.css'),app=read('app.js');
const html=read('index.template.html').replace('/* STYLES */',css).replace('/* DATA */',()=>data).replace('/* APP */',()=>app);
fs.writeFileSync(path.join(dist,'dashboard.html'),html);
const s=JSON.parse(fs.readFileSync(path.join(root,'analysis.json'),'utf8'));
const points=Object.entries(s.monthly_respiratory),W=960,H=310,L=55,T=30,B=50,R=20,w=W-L-R,h=H-T-B,x=i=>L+i*w/(points.length-1),y=v=>T+h-v/1000*h;
let svg=`<svg class="line-chart" role="img" aria-label="2024~2025년 월별 호흡기 질환 청구 건수" viewBox="0 0 ${W} ${H}"><title>호흡기 질환 청구 건수의 계절성</title>`;
for(let v=0;v<=1000;v+=250)svg+=`<line class="chart-grid" x1="${L}" x2="${W-R}" y1="${y(v)}" y2="${y(v)}"/><text class="chart-axis" text-anchor="end" x="${L-12}" y="${y(v)+4}">${v}</text>`;
const line=points.map(([,v],i)=>`${i?'L':'M'}${x(i)},${y(v)}`).join(' ');
svg+=`<path d="${line} L${x(points.length-1)},${T+h} L${L},${T+h} Z" fill="#e7f3ef"/><path d="${line}" fill="none" stroke="#087f78" stroke-width="3"/>`;
points.forEach(([m,v],i)=>{svg+=`<circle class="chart-point" tabindex="0" cx="${x(i)}" cy="${y(v)}" r="4" aria-label="${m} ${v}건"><title>${m}: ${v}건</title></circle>`;if(i%2===0||i===23)svg+=`<text class="chart-axis" text-anchor="middle" x="${x(i)}" y="${H-18}">${m.slice(2).replace('-','.')}</text>`;});svg+='</svg>';
const graph=`<!doctype html><html lang="ko"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>과제 1 | 호흡기 질환 청구의 계절성</title><style>${css}</style></head><body><main class="graph-only"><p class="eyebrow">ASSIGNMENT 01 / SEASONALITY</p><h1>호흡기 질환 청구는 겨울철에 더 많을까?</h1><p class="muted">병원 경영기획 담당자가 월별 진료 수요를 살펴보기 위한 시계열 분석</p><article class="panel"><div class="panel-head"><div><h2>2024~2025년 월별 호흡기 질환 명세서 수</h2><p class="sub">주상병 J코드 · 단위: 건 · 0부터 시작하는 세로축</p></div></div>${svg}<p class="chart-foot">출처: kr_claims 수업용 가상 데이터. 진료시작일(recu_fr_dd)의 월을 기준으로 명세서를 집계했습니다.</p></article><aside class="insight"><b>한 줄 인사이트</b><p>11~3월 월평균은 742.1건으로, 6~9월의 341.9건보다 약 2.17배 많습니다.</p></aside><p class="sub">2024~2025년의 11~3월 10개월과 6~9월 8개월을 비교했습니다. 실제 환자 기록이나 전국 질환 발생률을 나타내지 않습니다. 원인과 인과관계는 이 그래프만으로 판단할 수 없습니다.</p><details><summary>그래프 원자료 24개월 보기</summary><div class="table-scroll details-content"><table><thead><tr><th>진료월</th><th>호흡기 명세서(건)</th></tr></thead><tbody>${points.map(([m,v])=>`<tr><td>${m}</td><td>${v}</td></tr>`).join('')}</tbody></table></div></details><footer><a href="https://docs.google.com/spreadsheets/d/1nPuY8AKFAs2r9da4xUBV3WMKdLEBZJGpmd3kP7xKNvU">데이터 출처</a><a href="index.html">전체 대시보드 보기 →</a></footer></main></body></html>`;
fs.writeFileSync(path.join(dist,'graph.html'),graph);
console.log('Built index.html, dashboard.html, graph.html');

const output=path.join(dist,'_site');fs.mkdirSync(output,{recursive:true});
for(const name of ['index.html','dashboard.html','graph.html']) fs.copyFileSync(path.join(dist,name),path.join(output,name));
