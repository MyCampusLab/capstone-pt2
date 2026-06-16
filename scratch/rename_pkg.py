import os

def replace_in_file(filepath, old_str, new_str):
    try:
        with open(filepath, 'r') as f:
            content = f.read()
        if old_str in content:
            content = content.replace(old_str, new_str)
            with open(filepath, 'w') as f:
                f.write(content)
            print(f"Updated {filepath}")
    except Exception as e:
        print(f"Error reading {filepath}: {e}")

def main():
    root_dir = '/home/irsyad/Gudang/EyeGuardian/visionsafe'
    exclude_dirs = ['build', '.git', '.dart_tool', 'android/.gradle']
    
    for dirpath, dirnames, filenames in os.walk(root_dir):
        # Exclude directories
        dirnames[:] = [d for d in dirnames if d not in exclude_dirs]
        
        for file in filenames:
            filepath = os.path.join(dirpath, file)
            # Replace com.hn.visionsafe first
            replace_in_file(filepath, 'com.hn.visionsafe', 'com.hn.visionsafe')
            # Then replace com.hn.visionsafe
            replace_in_file(filepath, 'com.hn.visionsafe', 'com.hn.visionsafe')

if __name__ == '__main__':
    main()
