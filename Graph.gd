extends Node2D
class_name Graph

var _adjacency_list: Dictionary = {}
var color: Color
var line_width: float
#var edges: Array = []

static func _edge_comparator(a: Line2D, b: Line2D) -> bool:
	var a1: Vector2 = a.get_point_position(0)
	var a2: Vector2 = a.get_point_position(1)
	var b1: Vector2 = b.get_point_position(0)
	var b2: Vector2 = b.get_point_position(1)
	return (a1 == b1 && a2 == b2) || (a1 == b2 && a2 == b1)

func _init():
	color = Color("#89BDE5")
	line_width = 2.0

func get_edges() -> Array:
#	print("get")
	var comparator := funcref(get_node("."), "_edge_comparator")
	var edges := Set.new(comparator)
	for v1 in _adjacency_list.keys():
		for v2 in _adjacency_list[v1]:
			var edge := Line2D.new()
			edge.add_point(v1)
			edge.add_point(v2)
			edges.push(edge)
	return edges.data()

func add_edge(a: Vector2, b: Vector2) -> void:
#	print("ADD")
#	var edge := Line2D.new()
#	edge.width = 2
#	edge.begin_cap_mode = Line2D.LINE_CAP_ROUND
#	edge.end_cap_mode = Line2D.LINE_CAP_ROUND
#	edge.add_point(a)
#	edge.add_point(b)
#	edges.append(edge)
#	add_child(edge)
#	if !_adjacency_list.has(a):
#		_adjacency_list[a] = []
#	_adjacency_list[a].append(b)
#
#	if !_adjacency_list.has(b):
#		_adjacency_list[b] = []
#	_adjacency_list[b].append(a)
	update()

#func remove_edge(edge: Line2D) -> void:
#	var index: int = edges.find(edge)
#	edges.remove(index)
#	remove_child(edge)

func remove_edge(a: Vector2, b: Vector2) -> void:
#	print("REMOVE")
#	_adjacency_list[a].erase(b)
#	_adjacency_list[b].erase(a)
#	if len(_adjacency_list[a]) == 0:
#		_adjacency_list.erase(a)
#	if len(_adjacency_list[b]) == 0:
#		_adjacency_list.erase(b)
	update()
#	for vertex in _adjacency_list.keys():
#		if vertex == a:
#			_adjacency_list[a].erase(b)
#			_adjacency_list.erase(a)
#			return
#		elif vertex == b:
#			_adjacency_list[b].erase(a)
#			_adjacency_list.erase(a)
#			return

func _draw() -> void:
	var edges: Array = get_edges()
	for e in edges:
		draw_line(e.get_point_position(0), e.get_point_position(1), color, line_width, true)
