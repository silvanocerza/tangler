extends Node2D
class_name Graph

var _adjacency_list: Dictionary = {}
var color: Color
var line_width: float

func _init():
	color = Color("#89BDE5")
	line_width = 2.0

func get_nodes() -> Array:
	return _adjacency_list.keys()

func get_edges() -> Array:
	var edges: Array = []
	var visited: Array = []
	for node in _adjacency_list.keys():
		for e in get_edges_dfs(node, visited):
			edges.append(e)
	return edges

func add_edge(a: Vector2, b: Vector2) -> void:
	if !_adjacency_list.has(a):
		_adjacency_list[a] = []
	_adjacency_list[a].append(b)

	if !_adjacency_list.has(b):
		_adjacency_list[b] = []
	_adjacency_list[b].append(a)
	update()

func remove_edge(a: Vector2, b: Vector2) -> void:
	_adjacency_list[a].erase(b)
	_adjacency_list[b].erase(a)
	if len(_adjacency_list[a]) == 0:
		_adjacency_list.erase(a)
	if len(_adjacency_list[b]) == 0:
		_adjacency_list.erase(b)
	update()

func get_edges_dfs(node: Vector2, visited: Array) -> Array:
	var edges: Array = []
	if visited.count(node) == 0:
		visited.append(node)

		for n in _adjacency_list[node]:
			if visited.count(n) > 0:
				continue
			for e in get_edges_dfs(n, visited):
				edges.append(e)
			edges.append([node, n])
	return edges

func draw_graph(node: Vector2, visited: Array) -> void:
	if visited.count(node) == 0:
		visited.append(node)

		for n in _adjacency_list[node]:
			draw_graph(n, visited)
			draw_line(node, n, color, line_width, true)

func get_edges_bfs(node: Vector2, max_depth: int = -1) -> Array:
	var edges: Array = []
	var queue: Array = [node]
	var visited: Array = [node]

	var depth: int = 1
	while !queue.empty():
		var v: Vector2 = queue.pop_front();

		for n in _adjacency_list[v]:
			if visited.count(n) == 0:
				queue.push_back(n)
				visited.append(n)
				edges.append(n)
		if depth == max_depth:
			break
		depth += 1

	return edges

func move_node(node: Vector2, new_position: Vector2) -> void:
	if !_adjacency_list.has(node):
		return

	var adjancent_nodes: Array = _adjacency_list[node]
	for adjancent in adjancent_nodes:
		for n in _adjacency_list[adjancent]:
			if n == node:
				_adjacency_list[adjancent].erase(node)
				_adjacency_list[adjancent].append(new_position)

	_adjacency_list[new_position] = _adjacency_list[node]
	_adjacency_list.erase(node)

func _draw() -> void:
	var visited: Array = []
	for n in _adjacency_list.keys():
		draw_graph(n, visited)
