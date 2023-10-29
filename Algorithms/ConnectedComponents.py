def conncompedit(nvertices,G, exception = -1):
  temp = nvertices; start = 0; firstrun =  True
  if exception != -1:
    temp = nvertices +1
    if start +1 == exception:
      start = 0
    else: start = 1
  discovered = [False] * (temp)
  processed = [False] * (temp)
  todo = deque([start])
  components = {}
  ans = 0 
  while (sum(discovered) < nvertices):
    i=0
    ans +=1
    for a in discovered:
      if firstrun:
        firstrun = False
        break
      if i!= exception and not a:
        if not G[i]:
          discovered[i] = True
          components[i] = ans
        else:
          todo.append(i)
        break
      i+=1
    while todo:
      current = todo.popleft()
      discovered[current] = True
      components[current] = ans
      for b in G[current]:
        if not discovered[b]:
          todo.append(b)
          components[b] = ans
          discovered[b] = True
      processed[current] = True
  return ans, components
