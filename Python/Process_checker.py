import psutil

def get_top_processes(n=10):
    # Get all running processes
    processes = [proc for proc in psutil.process_iter(['pid', 'name', 'username', 'cpu_percent', 'memory_percent', 'io_counters'])]

    # Sort by CPU usage and print the top n processes
    top_cpu = sorted(processes, key=lambda proc: proc.info['cpu_percent'], reverse=True)[:n]
    print(f"Top {n} processes by CPU usage:")
    for proc in top_cpu:
        print(f"PID: {proc.info['pid']}, Name: {proc.info['name']}, User: {proc.info['username']}, CPU usage: {proc.info['cpu_percent']}%")

    print('-' * 50)

    # Sort by memory usage and print the top n processes
    top_mem = sorted(processes, key=lambda proc: proc.info['memory_percent'], reverse=True)[:n]
    print(f"Top {n} processes by memory usage:")
    for proc in top_mem:
        print(f"PID: {proc.info['pid']}, Name: {proc.info['name']}, User: {proc.info['username']}, Memory usage: {proc.info['memory_percent']}%")

get_top_processes()