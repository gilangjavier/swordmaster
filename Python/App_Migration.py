import paramiko
import getpass

def interactive_app_migration():
    host = input("Enter the source host: ")
    user = input("Enter the source username: ")
    password = getpass.getpass("Enter the source password: ")
    source_path = input("Enter the source path: ")

    dest_host = input("Enter the destination host: ")
    dest_user = input("Enter the destination username: ")
    dest_password = getpass.getpass("Enter the destination password: ")
    dest_path = input("Enter the destination path: ")

    ssh = paramiko.SSHClient()
    ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

    try:
        ssh.connect(host, username=user, password=password)
        sftp = ssh.open_sftp()

        print("Copying application files...")
        sftp.put(source_path, dest_path)

        sftp.close()
        ssh.close()

        print("Application files copied successfully.")
    except Exception as e:
        print("An error occurred:", e)

if __name__ == "__main__":
    interactive_app_migration()
