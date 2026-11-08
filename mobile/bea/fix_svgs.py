import os
import re

def fix_path_data(d):
    # This is a more aggressive fix for path data
    # 1. Expand all commands (add spaces around them)
    d = re.sub(r'([a-zA-Z])', r' \1 ', d)
    
    # 2. Add spaces between numbers where signs are used as separators
    # e.g., 10-5 -> 10 -5
    # SVG allows this, but let's be safe.
    d = re.sub(r'([0-9])\-', r'\1 -', d)
    d = re.sub(r'([0-9])\+', r'\1 +', d)
    
    # 3. Add spaces between numbers where dots are used as separators
    # e.g., 1.2.3 -> 1.2 0.3
    # We do this until no more changes happen.
    while True:
        # Match a decimal number followed by a dot
        new_d = re.sub(r'([0-9]+\.[0-9]+)\.', r'\1 0.', d)
        if new_d == d:
            break
        d = new_d
        
    # 4. Leading dots: .5 -> 0.5
    d = re.sub(r'(?<![0-9])\.([0-9])', r' 0.\1 ', d)
    
    # 5. Clean up multiple spaces and commas
    d = d.replace(',', ' ')
    d = re.sub(r'\s+', ' ', d).strip()
    
    return d

icons_dir = 'assets/icons'
if os.path.exists(icons_dir):
    for filename in os.listdir(icons_dir):
        if filename.endswith('.svg'):
            filepath = os.path.join(icons_dir, filename)
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Fix attributes
            def replace_attr(match):
                prefix = match.group(1)
                val = match.group(2)
                if prefix == 'd':
                    val = fix_path_data(val)
                else:
                    # For viewBox or others, just ensure leading dots are fixed
                    val = re.sub(r'(?<![0-9])\.([0-9])', r'0.\1', val)
                return f'{prefix}="{val}"'

            new_content = re.sub(r'([a-zA-Z]+)="([^"]+)"', replace_attr, content)
            
            # Final sanity checks
            new_content = new_content.replace('w3.0org', 'w3.org')
            
            if new_content != content:
               debugPrint(f"Fixing {filename}")
                with open(filepath, 'w', encoding='utf-8') as f:
                    f.write(new_content)
else:
   debugPrint(f"Directory {icons_dir} not found")
