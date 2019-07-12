extends Node2D
class_name Graph

var _adjacency_list: Dictionary = {}
var color: Color
var line_width: float

func _init():
	color = Color("#89BDE5")
	line_width = 2.0
	
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
			var edge := Line2D.new()
			edge.points = [node, n]
			edges.append(edge)
	return edges

func draw_graph(node: Vector2, visited: Array) -> void:
	if visited.count(node) == 0:
		visited.append(node)
		
		for n in _adjacency_list[node]:
			draw_graph(n, visited)
			draw_line(node, n, color, line_width, true)

func _draw() -> void:
	var visited: Array = []
	for n in _adjacency_list.keys():
		draw_graph(n, visited)
