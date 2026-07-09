#!/usr/bin/env bash
# Read-only preflight for Puppet Server/agent maintenance and upgrades.
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"; ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd -P)"
puppet_version=''; server_version=''; java_major=''; free_mib=''; backup_age=''; output=''
usage(){ printf 'Usage: %s [--puppet-version V] [--server-version V] [--java-major N] [--free-mib N] [--backup-age SECONDS] [--output FILE]\n' "$0"; }
while (($#)); do case "$1" in --puppet-version) shift; puppet_version="${1:-}";; --server-version) shift; server_version="${1:-}";; --java-major) shift; java_major="${1:-}";; --free-mib) shift; free_mib="${1:-}";; --backup-age) shift; backup_age="${1:-}";; --output) shift; output="${1:-}";; -h|--help) usage; exit 0;; *) usage >&2; exit 64;; esac; shift; done
[[ -n "$puppet_version" ]] || puppet_version=$(puppet --version 2>/dev/null || echo 0)
[[ -n "$server_version" ]] || server_version=$(puppetserver --version 2>/dev/null | grep -Eo '[0-9]+(\.[0-9]+)+' | head -1 || echo 0)
[[ -n "$java_major" ]] || java_major=$(java -version 2>&1 | sed -n 's/.*version "\([0-9][0-9]*\).*/\1/p' | head -1); java_major=${java_major:-0}
[[ -n "$free_mib" ]] || free_mib=$(df -Pm / | awk 'NR==2{print $4}')
[[ -n "$backup_age" ]] || backup_age=999999999
python3 - "$ROOT/config/operations-policy.json" "$puppet_version" "$server_version" "$java_major" "$free_mib" "$backup_age" "$output" <<'PY'
import json,sys,time,pathlib
pol=json.load(open(sys.argv[1]))['upgrade']; puppet,server=sys.argv[2],sys.argv[3]; java=int(sys.argv[4]); free=int(sys.argv[5]); age=int(sys.argv[6]); out=sys.argv[7]
def major(v):
 try:return int(v.split('.')[0])
 except:return 0
checks=[]
def add(name,status,detail):checks.append({'name':name,'status':status,'detail':detail})
pm=major(puppet); sm=major(server)
add('agent-major','pass' if pm in pol['supported_agent_majors'] else 'fail',f'Puppet {puppet}')
add('server-major','pass' if sm in pol['supported_server_majors'] else 'fail',f'Puppet Server {server}')
add('java-major','pass' if java==pol['preferred_java_major'] else 'warn',f'Java {java}; preferred {pol["preferred_java_major"]}')
add('free-space','pass' if free>=pol['minimum_free_mib'] else 'fail',f'{free} MiB free')
add('backup-age','pass' if age<=pol['maximum_backup_age_seconds'] else 'fail',f'{age}s old')
if pm==7:add('puppet-7-lifecycle','warn','Puppet 7 compatibility is tested for distribution agents but should not be selected for a new server')
status='fail' if any(x['status']=='fail' for x in checks) else ('warn' if any(x['status']=='warn' for x in checks) else 'pass')
r={'schema_version':1,'generated_at_epoch':int(time.time()),'status':status,'checks':checks}
t=json.dumps(r,indent=2)+'\n'
if out:pathlib.Path(out).write_text(t)
else:print(t,end='')
raise SystemExit(3 if status=='fail' else (2 if status=='warn' else 0))
PY
