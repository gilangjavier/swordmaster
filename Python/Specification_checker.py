import os
import subprocess

def get_output(command):
    return subprocess.check_output(command, shell=True).decode('utf-8')

def get_specs():
    specs = {}

    # Basic hardware specs
    specs['CPU'] = get_output("lscpu")
    specs['Memory'] = get_output("free -h")
    specs['Disk'] = get_output("df -h")

    # Network
    specs['IP Address'] = get_output("hostname -I")
    specs['Routing Table'] = get_output("netstat -rn")

    # I/O
    specs['I/O Statistics'] = get_output("iostat")

    # Storage
    specs['Block Devices'] = get_output("lsblk")

    # Firewall
    specs['Firewall'] = get_output("sudo ufw status verbose")

    # Installed packages
    specs['Packages'] = get_output("dpkg-query -l")

    return specs

specs = get_specs()

for category, output in specs.items():
    print(f"{category}\n{'-' * len(category)}")
    print(output)