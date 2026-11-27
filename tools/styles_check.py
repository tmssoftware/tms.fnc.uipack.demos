"""Run Styles self-checks on the hidden desktop, through the harness machine lock.

Run with heavy.py, passing the harness root and democheck compile JSON.
"""
import argparse
import json
import sys
from pathlib import Path

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('--harness', type=Path, required=True)
parser.add_argument('--builds', type=Path, required=True)
args = parser.parse_args()
sys.path.insert(0, str(args.harness / 'tools'))
import hidden_desktop

repo = Path(__file__).resolve().parents[1]
results = []
for demo, builds in json.loads(args.builds.read_text()).items():
    framework = demo.split('/')[0].upper()
    for platform, build in builds.items():
        if not build['ok']:
            raise SystemExit(f'Build failed: {demo} {platform}')
        for ppi in ([96, 120, 144, 192] if platform.endswith('win32') else [96]):
            output = repo / framework / 'Styles' / 'output' / f'{platform}-{ppi}'
            output.mkdir(parents=True, exist_ok=True)
            for name in ('success.txt', 'error.txt'):
                (output / name).unlink(missing_ok=True)
            for capture in output.glob('[0-9][0-9]-*.png'):
                capture.unlink()
            code = hidden_desktop.run([build['exe'], '--self-check', '--output', str(output), '--ppi', str(ppi)], timeout=90)
            captures = list(output.glob('[0-9][0-9]-*.png'))
            marker = output / 'success.txt'
            error = output / 'error.txt'
            success = (
                code == 0 and len(captures) == 4 and marker.is_file() and not error.exists()
                and marker.read_text().strip() == f'{len(captures)} styles captured'
            )
            record = dict(demo=demo, platform=platform, ppi=ppi, exit=code, ok=success, output=str(output))
            results.append(record)
            print(json.dumps(record), flush=True)
            if not success:
                if error.is_file():
                    print(error.read_text())
args.builds.with_name('self-check.json').write_text(json.dumps(results, indent=2))
raise SystemExit(0 if results and all(record['ok'] for record in results) else 1)
