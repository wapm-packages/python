import http.client

conn = http.client.HTTPConnection("localhost", 8000)
conn.request("GET", "/")
response = conn.getresponse()

print(f"pyDEBUG {response.status} {response.reason}")
print(f"pyDEBUG {response}")
