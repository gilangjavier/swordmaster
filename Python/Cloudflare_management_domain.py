# Install Flarectl First in Your Device 
import subprocess

def get_domains(zone):
    try:
        output = subprocess.check_output(f'flarectl zone list | grep {zone}', shell=True).decode('utf-8').strip()
        print(output)
    except subprocess.CalledProcessError as e:
        print(f"Error getting domains for zone {zone}: {str(e)}")

def add_record(zone, record_type, name, content, ttl):
    try:
        command = f'flarectl dns create --zone {zone} --type {record_type} --name {name} --content {content} --ttl {ttl}'
        output = subprocess.check_output(command, shell=True).decode('utf-8').strip()
        print(output)
    except subprocess.CalledProcessError as e:
        print(f"Error adding record to zone {zone}: {str(e)}")

def delete_record(zone, record_id):
    try:
        command = f'flarectl dns delete --zone {zone} --id {record_id}'
        output = subprocess.check_output(command, shell=True).decode('utf-8').strip()
        print(output)
    except subprocess.CalledProcessError as e:
        print(f"Error deleting record from zone {zone}: {str(e)}")

def main():
    print("1. Get domain")
    print("2. Add record")
    print("3. Delete record")

    choice = input("Choose an option: ")

    if choice == '1':
        zone = input("Enter the zone: ")
        get_domains(zone)
    elif choice == '2':
        zone = input("Enter the zone: ")
        record_type = input("Enter the record type (A, CNAME, etc.): ")
        name = input("Enter the name: ")
        content = input("Enter the content: ")
        ttl = input("Enter the TTL: ")
        add_record(zone, record_type, name, content, ttl)
    elif choice == '3':
        zone = input("Enter the zone: ")
        record_id = input("Enter the record ID: ")
        delete_record(zone, record_id)
    else:
        print("Invalid option")

main()