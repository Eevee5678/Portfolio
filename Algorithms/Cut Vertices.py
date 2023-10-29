def recurs (edges, start, nvertices):
  disc = [False] * (nvertices)
  parent = [-1] * (nvertices)
  timein = {}
  earliest = {}
  cut = set()
  time = 0
  def recursivcut(edges, current, disc, parent, timein, earliest, cut):
    nonlocal time
    children = 0
    disc[current] = True
    timein[current] = time
    earliest[current] = time
    time +=1
    for b in edges[current]:
      if not disc[b]:
        parent[b] = current
        children +=1
        recursivcut(edges,b,disc,parent,timein,earliest,cut)
        earliest[current] = min (earliest[current], earliest[b])
        if parent[current] == -1 and children > 1:
          cut.add(current)
        if parent[current] != -1 and earliest[b] >= timein[current]:
          cut.add(current)
      elif b != parent[current]:
        earliest[current] = min (earliest[current], timein[b])
  recursivcut(edges,start,disc,parent,timein, earliest, cut)
  return cut
