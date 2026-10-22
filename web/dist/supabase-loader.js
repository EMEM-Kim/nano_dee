'use strict';
async function loadSupabaseClaims(config, request=fetch) {
  if (!config?.url || !config?.key) throw new Error('config.js에 Supabase URL과 공개 키를 설정해 주세요.');
  const endpoint=new URL(config.url);
  if(endpoint.protocol!=='https:') throw new Error('Supabase URL은 https로 시작해야 합니다.');
  const rows=[], types={}, diseases={};
  for(let offset=0;;) {
    const url=new URL('/rest/v1/dashboard_claims',endpoint);
    url.search=new URLSearchParams({select:'id,month,patient,type,disease,cost,form,type_name,disease_name',order:'id.asc',offset:String(offset),limit:'1000'});
    const response=await request(url,{headers:{apikey:config.key},signal:AbortSignal.timeout(20000)});
    if(!response.ok) throw new Error(`데이터 조회 실패 (${response.status}). 테이블·키·RLS를 확인하세요.`);
    const page=await response.json();
    if(!Array.isArray(page)) throw new Error('조회 결과 형식이 올바르지 않습니다.');
    if(!page.length) break;
    for(const r of page) {
      if(!Number.isSafeInteger(Number(r.cost)) || Number(r.cost)<0 || !/^20\d{2}-(0[1-9]|1[0-2])$/.test(r.month) || !r.patient || !r.disease || !r.type || !r.form) throw new Error('데이터 값 검증에 실패했습니다.');
      rows.push([r.month,String(r.patient),r.type,r.disease,Number(r.cost),r.form]);
      types[r.type]=r.type_name; diseases[r.disease]=r.disease_name;
    }
    offset+=page.length;
    // 서버가 1000보다 작은 페이지 제한을 사용해도 빈 페이지까지 읽는다.
  }
  if(!rows.length) throw new Error('조회된 데이터가 없습니다. CSV 업로드와 읽기 정책을 확인하세요.');
  return {rows,types,diseases,counts:{claim:rows.length,institution:'연결형',sick_master:Object.keys(diseases).length}};
}
window.loadSupabaseClaims=loadSupabaseClaims;
if(document.getElementById('connection-status')) (async()=>{
  const status=document.getElementById('connection-status');
  try {
    window.CLAIMS_DATA=await loadSupabaseClaims(window.SUPABASE_CONFIG);
    status.textContent=`Supabase 조회 완료 · ${window.CLAIMS_DATA.rows.length.toLocaleString()}건 · ${new Date().toLocaleString('ko-KR')}`;
    const app=document.createElement('script');app.src='app.js';
    app.onload=()=>{document.getElementById('source-counts').textContent=`Supabase 교육용 합성 데이터 ${window.CLAIMS_DATA.rows.length.toLocaleString()}행. 새로고침하면 다시 조회합니다.`;};
    document.body.append(app);
  } catch(error) { status.textContent=error.message;status.setAttribute('role','alert'); }
})();
