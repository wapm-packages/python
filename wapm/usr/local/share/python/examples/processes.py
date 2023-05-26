from multiprocessing import Process
from time import sleep
import subprocess

def hello(name):
    print(f"pyDEBUG hello {name}, i'm a subprocess")

if __name__ == '__main__':
    p = Process(target=hello, args=('meow',))
    p.start()
    p.join()

    ret = subprocess.run(['/bin/ls'], capture_output=True)
    print(f"pyDEBUG {ret}")
    print(f"pyDEBUG {ret.stdout}")
    print(f"pyDEBUG {ret.stderr}")
