extends Node2D

var max_x: float
var max_y: float
var graph: Graph

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_x = get_viewport().size[0]
	max_y = get_viewport().size[1]
	graph = load("res://Graph.gd").new()
	add_child(graph)
	create_edges()

func create_edges() -> void:
	randomize()
	for i in range(0, 6):
		var x1: float = rand_range(0, max_x)
		var y1: float = rand_range(0, max_y)
		var x2: float = rand_range(0, max_x)
		var y2: float = rand_range(0, max_y)
		# Maybe we could avoid intersections
		graph.add_edge(Vector2(x1, y1), Vector2(x2, y2))

func intersect(a: Line2D, b: Line2D) -> Dictionary:
	var a0: Vector2 = a.get_point_position(0)
	var a1: Vector2 = a.get_point_position(1)
	var b0: Vector2 = b.get_point_position(0)
	var b1: Vector2 = b.get_point_position(1)

	var sa: Vector2 = a1 - a0
	var sb: Vector2 = b1 - b0
	var cross: float = sa.cross(sb)

	if abs(cross) <= 0:
		return {'intersect': false}

	var ba: Vector2 = a0 - b0
	var q: float = sa.cross(ba) / cross
	var p: float = sb.cross(ba) / cross

	var intersect: bool = p >= 0 && p <= 1 && q >= 0 && q <= 1
	return {'intersect': intersect, 'point': lerp(a0, a1, p)}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	randomize()
	# Creates new random line
	var candidate := Line2D.new()
	for i in range(0, 2):
		var x: float = rand_range(0, max_x)
		var y: float = rand_range(0, max_y)
		candidate.add_point(Vector2(x, y))

	# Finds intersection with existing lines
	# If we want we can customize it so that it stops after
	# two intersections are found
	var intersections := {}
	for edge in graph.get_edges():
		var i: Dictionary = intersect(candidate, edge)
		if i.get('intersect'):
			intersections[edge] = i

	# Splits intersected edges
	for edge in intersections:
		var point: Vector2 = intersections[edge].get('point')
		graph.add_edge(edge.get_point_position(0), point)
		graph.add_edge(point, edge.get_point_position(1))
		graph.remove_edge(edge)

	# Creates new edge from candidate line
	var values: Array = intersections.values()
	for i in range(0, len(values)):
		graph.add_edge(values[i-1].get('point'), values[i].get('point'))
