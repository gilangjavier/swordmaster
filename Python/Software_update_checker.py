import subprocess

def check_updates():
    # Update the package list
    subprocess.run(['sudo', 'apt', 'update'])

    # Check for upgradable packages
    output = subprocess.check_output(['apt', 'list', '--upgradable'], text=True)

    if "Listing..." in output:
        print("No updates available.")
    else:
        print("The following packages can be updated:")
        print(output)

    # Check for security updates
    security_updates = subprocess.check_output(['apt-get', '-s', 'upgrade'], text=True)
    security_updates = [line for line in security_updates.split('\n') if '/security' in line]
    
    if security_updates:
        print("The following security updates are available:")
        for update in security_updates:
            print(update)
    else:
        print("No security updates available.")

def apply_updates():
    check = input("Do you want to apply all available updates now? (y/N): ")
    if check.lower() == 'y':
        print("Applying updates. This may take some time...")
        subprocess.run(['sudo', 'apt', 'upgrade', '-y'])
    elif check.lower() == 'n':
        print("Updates will not be applied.")

check_updates()
apply_updates()