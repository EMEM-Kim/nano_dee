"""Build the dashboard from the unmodified course workbook (Python + openpyxl)."""
from pathlib import Path
import json, csv, sys, collections
import openpyxl

sys.stdout.reconfigure(encoding='utf-8')
root=Path(__file__).parent
wb=openpyxl.load_workbook(root.parent/'data/kr_claims.xlsx',read_only=True,data_only=True)
def records(name):
    it=wb[name].values
    headers=next(it)
    return [dict(zip(headers,row)) for row in it if any(v is not None for v in row)]
claims=records('claim'); institutions=records('institution'); diseases=records('sick_master'); codes=records('code_table')
inst={r['yid']:r for r in institutions}; names={r['sickcd']:r['krnm'] for r in diseases}
print('code types:',collections.Counter(r['code_type'] for r in codes))
print('institution codes:',collections.Counter(r['cl_cd'] for r in institutions))
print('relevant codes:',[r for r in codes if '종별' in str(r['code_type']) or '서식' in str(r['code_type']) or '권역' in str(r['code_type'])])
cl_names={'01':'상급종합병원','11':'종합병원','21':'병원','28':'요양병원','29':'정신병원','31':'의원','41':'치과병원','51':'치과의원','61':'조산원','71':'보건소','72':'보건지소','73':'보건진료소','81':'약국','92':'한방병원','93':'한의원'}
cl_codes=[r for r in codes if r['code_type']=='종별코드']
for r in cl_codes: cl_names[str(r['code'])]=r['code_nm']
rows=[]
for r in claims:
    i=inst.get(r['yid'],{})
    rows.append([r['recu_fr_dd'][:7],str(r['jid']),str(i.get('cl_cd','unknown')),r['main_sick'],int(r['rvd_rpe_tamt_amt']),r['fom_tp_cd']])
assert len({r['mid'] for r in claims})==len(claims),'Duplicate claim primary keys'
assert len(inst)==len(institutions),'Duplicate institution keys'
assert all(r['yid'] in inst for r in claims),'Unmatched institution'
assert all(r[4]>=0 for r in rows)
used={r[3] for r in rows}
payload={'source':'https://docs.google.com/spreadsheets/d/1nPuY8AKFAs2r9da4xUBV3WMKdLEBZJGpmd3kP7xKNvU','retrieved':'2026-10-22','columns':['month','patient','type','disease','cost','form'],'rows':rows,'types':{k:v for k,v in cl_names.items() if k in {r[2] for r in rows}},'diseases':{k:names.get(k,k) for k in used},'counts':{'claim':len(claims),'institution':len(institutions),'sick_master':len(diseases)}}
(root/'dist'/'data.js').write_text('window.CLAIMS_DATA='+json.dumps(payload,ensure_ascii=False,separators=(',',':'))+';',encoding='utf-8')
monthly=collections.Counter(r[0] for r in rows if r[3].startswith('J'))
summary={'claims':len(rows),'total_cost':sum(r[4] for r in rows),'patients':len({r[1] for r in rows}),'top_diseases':collections.Counter(r[3] for r in rows).most_common(10),'monthly_respiratory':dict(sorted(monthly.items())),'types':{},'source_counts':payload['counts']}
for k,v in payload['types'].items():
    group=[r for r in rows if r[2]==k]
    summary['types'][k]={'name':v,'count':len(group),'total':sum(r[4] for r in group),'average':sum(r[4] for r in group)/len(group)}
winter=[v for m,v in monthly.items() if m[-2:] in ('11','12','01','02','03')]
summer=[v for m,v in monthly.items() if m[-2:] in ('06','07','08','09')]
summary['winter_mean']=sum(winter)/len(winter);summary['summer_mean']=sum(summer)/len(summer)
(root/'analysis.json').write_text(json.dumps(summary,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps(summary,ensure_ascii=False,indent=2))
