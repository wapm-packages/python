import socket

if __name__ == "__main__":
    hosts = ["wasmer.io", "google.com"]
    for host in hosts:
        port = 80
        print(f"pyDEBUG creating socket")
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.settimeout(2)
        print(f"pyDEBUG connecting to {host} at {port}")
        s.connect((host, port))
        print(f"pyDEBUG connected")
