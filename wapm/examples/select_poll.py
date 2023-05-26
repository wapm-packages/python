print("pyDEBUG: importing select")
import select
print("pyDEBUG: select imported")

print("pyDEBUG: creating poller object")
poller = select.poll()

print("pyDEBUG: polling with timeout of 2")
poller.poll(2000)
print("pyDEBUG: polling finished")

print("pyDEBUG: polling with timeout of 1")
poller.poll(1)
print("pyDEBUG: polling finished")

print("pyDEBUG: polling with timeout of 0")
poller.poll(0)
print("pyDEBUG: polling finished")
