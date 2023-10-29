from collections import deque
def bfs(nvertices, edges, color, start): 
  discovered = [i==start for i in range (nvertices+1)]
  processed = [False] * (nvertices +1)
  todo = deque([start])
  parent = [0] * (nvertices +1)

  while todo:
    current = todo.popleft()
    for b in edges[current]:
      if not discovered[b]:
        todo.append(b)
        discovered[b] = True
        parent[b] = current
        if color[b].lower() == color[current].lower():
          return False
    processed[current] = True
  return True

coloring = {1:"red", 2: "blue", 3:"green", 4:"pink", 5:"yellow"}
coloring2 = {1:"red", 2:"red", 3:"green", 4:"pink", 5:"yellow"}
n = 5
edge = {1:[2,3], 2:[4], 3:[5], 4:[], 5:[]}

print(bfs(n, edge, coloring, 1)) #True
print(bfs(n, edge, coloring2, 1)) #False
