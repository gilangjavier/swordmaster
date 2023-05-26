import os
import subprocess

def get_size(start_path='.'):
    total_size = 0
    for dirpath, dirnames, filenames in os.walk(start_path):
        for f in filenames:
            fp = os.path.join(dirpath, f)
            # skip if it is symbolic link
            if not os.path.islink(fp):
                total_size += os.path.getsize(fp)
    return total_size

def check_docker():
    try:
        subprocess.check_output('docker -v', shell=True)
        return True
    except subprocess.CalledProcessError:
        return False

# Check size of the current directory and all its subdirectories
print(f"Size of the current directory: {get_size()} bytes")

if check_docker():
    # Check size of Docker images
    output = subprocess.check_output('docker images --format "{{.Size}}"', shell=True).decode('utf-8').strip()
    sizes = output.split('\n')
    total_docker_size = sum(int(size[:-2]) for size in sizes if 'MB' in size)*1024*1024 + sum(int(size[:-2]) for size in sizes if 'GB' in size)*1024*1024*1024
    print(f"Total size of Docker images: {total_docker_size} bytes")
else:
    print("Docker Engine is not installed, skipping Docker image size check.")