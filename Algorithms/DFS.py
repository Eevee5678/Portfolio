def dfsr (nvertices,edges, start):
  timein = {}
  timeout = {}
  visited = [False] * (nvertices +1)
  time = 0
  parent = {start:0}
  def recursivedfs (start):
    nonlocal time
    current = start
    if not visited[current]:
      visited[current] = True
      time +=1
      timein[current] = time
    for b in edges[current]:
      if not visited[b]:
        parent[b] = current
        recursivedfs(b) 
    time +=1
    timeout[current] = time
  recursivedfs(start)
  return parent, timein, timeout

def dfsi (nvertices, start, edges):
  discovered = [False] * (nvertices +1)
  parent =  {start:0}
  timein = {}
  timeout = {}
  now = 0
  stack = [start]
  while stack: 
    current = stack[-1]
    now +=1
    if current in timein:
      timeout [current] = now
      stack.pop()
      continue
    else: 
      timein [current] = now
      discovered[current] = True
    for b in sorted(edges[current], reverse = True):
      if not discovered[b]:
        stack.append(b)
        discovered[b] = True
        parent [b] = current
  return parent,timein,timeout
