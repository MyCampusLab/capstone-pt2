import re
import os
import subprocess

# The mapping from bracket numbers to bibtex keys
mapping = {
    '1': 'tariq_baas_2021',
    '2': 'huang_scalable_2022',
    '3': 'supabase_architecture_2023',
    '4': 'kim_rls_2021',
    '5': 'rahman_security_2022',
    '6': 'das_jwt_2021',
    '7': 'postgresql_rls_2023',
    '8': 'wang_energy_2022',
    '9': 'chen_reducing_2021',
    '11': 'baker_throttling_2022',
    '12': 'sharma_websocket_2021',
    '14': 'patel_managing_2021',
    '15': 'hernandez_privacy_2021',
    '16': 'lee_parental_2022',
    '17': 'iso25010_2011_irsyad',
    '18': 'gupta_evaluating_2021',
    '19': 'fernandez_security_2022'
}

# Read the draft
with open('irsyad_04_B_Bab_Pendahuluan.md', 'r', encoding='utf-8') as f:
    content = f.read()

# Extract just the top part (the actual draft, ignore the guide)
draft_part = content.split('---')[0].strip()

# Function to replace bracket patterns like [1], [2] or [1] with Pandoc citation syntax
# First, let's just replace all individual [X] with [@key]
# Note: Pandoc handles multiple consecutive citations nicely if put together, 
# but if we replace [1] with [@tariq_baas_2021], and [2] with [@huang_scalable_2022]
# resulting in [@tariq_baas_2021], [@huang_scalable_2022], pandoc will render it fine.
# But for perfect formatting, we can replace '[1], [2]' with '[@tariq_baas_2021; @huang_scalable_2022]'

def replacer(match):
    num = match.group(1)
    if num in mapping:
        return f"[@{mapping[num]}]"
    return match.group(0)

# Replace all [number]
draft_part = re.sub(r'\[(\d+)\]', replacer, draft_part)

# Fix double brackets: [@key], [@key2] -> [@key; @key2]
draft_part = re.sub(r'\]\s*,\s*\[', '; ', draft_part)

# Write to a temp markdown file
with open('temp_draft.md', 'w', encoding='utf-8') as f:
    f.write("# Bab Pendahuluan\n\n")
    f.write(draft_part)
    f.write("\n\n# Daftar Pustaka\n")

# Run Pandoc
# Output to a docx file
command = [
    'pandoc',
    'temp_draft.md',
    '-s',
    '-o', 'Draft_Pendahuluan_Terotomatisasi.docx',
    '--citeproc',
    '--bibliography=irsyad_references.bib',
    '--csl=ieee.csl'
]

print("Running Pandoc...")
result = subprocess.run(command, capture_output=True, text=True)
if result.returncode == 0:
    print("Berhasil membuat file Word: Draft_Pendahuluan_Terotomatisasi.docx")
else:
    print("Error:", result.stderr)

# Clean up
os.remove('temp_draft.md')
