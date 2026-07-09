#!/usr/bin/env python3
"""Convert compact compliance and health JSON into low-cardinality monitoring output."""
from __future__ import annotations
import argparse,json,os,tempfile,time
from pathlib import Path

def load(path:Path):
    with path.open(encoding='utf-8') as f: return json.load(f)
def atomic_write(path:Path,text:str):
    path.parent.mkdir(parents=True,exist_ok=True)
    fd,tmp=tempfile.mkstemp(prefix='.'+path.name+'.',dir=str(path.parent),text=True)
    try:
        with os.fdopen(fd,'w',encoding='utf-8') as f: f.write(text); f.flush(); os.fsync(f.fileno())
        os.chmod(tmp,0o640); os.replace(tmp,path)
    finally:
        if os.path.exists(tmp): os.unlink(tmp)
def esc(v): return str(v).replace('\\','\\\\').replace('"','\\"').replace('\n','\\n')
p=argparse.ArgumentParser(); p.add_argument('--compliance',type=Path,required=True); p.add_argument('--health',type=Path,required=True); p.add_argument('--format',choices=['prometheus','json','nagios'],default='prometheus'); p.add_argument('--output',type=Path); p.add_argument('--now',type=int,default=int(time.time())); a=p.parse_args()
try:
    compliance=load(a.compliance); health=load(a.health)
    summary=compliance.get('summary',{}); nodes=compliance.get('nodes',[])
    bad={'failed','invalid-report','unknown-report-status','retired-pending-decommission','invalid-maintenance-expiry'}
    warn={'stale-report','missing-report','maintenance-expired'}
    critical=sum(int(summary.get(x,0)) for x in bad); warnings=sum(int(summary.get(x,0)) for x in warn)
    health_status=health.get('status','critical'); health_value={'ok':0,'warning':1,'critical':2}.get(health_status,2)
    exit_code=2 if critical or health_value==2 else (1 if warnings or health_value==1 else 0)
except Exception as exc:
    compliance={'summary':{},'nodes':[]}; health={'status':'critical','message':str(exc)}; summary={}; nodes=[]; critical=1; warnings=0; health_value=2; exit_code=2
result={'schema_version':1,'generated_at_epoch':a.now,'status':'critical' if exit_code==2 else ('warning' if exit_code==1 else 'ok'),'node_count':len(nodes),'warning_nodes':warnings,'critical_nodes':critical,'control_plane_status':health.get('status','critical')}
if a.format=='json': text=json.dumps(result,indent=2,sort_keys=True)+'\n'
elif a.format=='nagios': text=f"SASD_PUPPET {result['status'].upper()} - nodes={len(nodes)} warning={warnings} critical={critical} control_plane={result['control_plane_status']}\n"
else:
    lines=['# HELP sasd_puppet_fleet_nodes Number of inventoried nodes by compact compliance status.','# TYPE sasd_puppet_fleet_nodes gauge']
    for status,count in sorted(summary.items()): lines.append(f'sasd_puppet_fleet_nodes{{status="{esc(status)}"}} {int(count)}')
    lines += ['# HELP sasd_puppet_fleet_problem_nodes Nodes requiring warning or critical attention.','# TYPE sasd_puppet_fleet_problem_nodes gauge',f'sasd_puppet_fleet_problem_nodes{{severity="warning"}} {warnings}',f'sasd_puppet_fleet_problem_nodes{{severity="critical"}} {critical}','# HELP sasd_puppet_control_plane_status Control-plane state: 0 ok, 1 warning, 2 critical.','# TYPE sasd_puppet_control_plane_status gauge',f'sasd_puppet_control_plane_status {health_value}','# HELP sasd_puppet_monitoring_export_timestamp_seconds Unix timestamp of this export.','# TYPE sasd_puppet_monitoring_export_timestamp_seconds gauge',f'sasd_puppet_monitoring_export_timestamp_seconds {a.now}']
    text='\n'.join(lines)+'\n'
if a.output: atomic_write(a.output,text)
else: print(text,end='')
raise SystemExit(exit_code)
