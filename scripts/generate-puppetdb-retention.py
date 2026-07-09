#!/usr/bin/env python3
"""Generate, but never install, a reviewed PuppetDB retention candidate."""
import argparse,json
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
p=argparse.ArgumentParser(); p.add_argument('--output',type=Path,required=True); a=p.parse_args()
pol=json.loads((ROOT/'config/operations-policy.json').read_text())['puppetdb']
text=('\n'.join(['# Generated SASD PuppetDB retention candidate. Review before installation.','[database]','node-ttl = {node_ttl}','node-purge-ttl = {node_purge_ttl}','report-ttl = {report_ttl}','resource-events-ttl = {resource_events_ttl}',''])).format(**pol)
a.output.parent.mkdir(parents=True,exist_ok=True); a.output.write_text(text); print(a.output)
