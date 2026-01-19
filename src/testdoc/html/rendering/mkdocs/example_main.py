import json
from pathlib import Path

def define_env(env):
    data_file = Path(__file__).parent / 'suites.json'
    env.variables['suites'] = json.loads(data_file.read_text(encoding='utf-8'))