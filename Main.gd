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
	create_triangles()

func create_triangles() -> void:
	randomize()
	var vertices := []
	for i in range(0, 3):
		var x: float = rand_range(0, max_x)
		var y: float = rand_range(0, max_y)
		vertices.append(Vector2(x, y))

	for i in range(0, len(vertices)):
		graph.add_edge(vertices[i-1], vertices[i])

func intersect(a: Line2D, b: Line2D) -> Dictionary:
	var a0: Vector2 = a.get_point_position(0)
	var a1: Vector2 = a.get_point_position(1)
	var b0: Vector2 = b.get_point_position(0)
	var b1: Vector2 = b.get_point_position(1)

	var sa: Vector2 = a1 - a0
	var sb: Vector2 = b1 - b0
	var cross: float = sa.cross(sb)

	# TODO: Handled cross == 0
	if abs(cross) <= 0:
		return {'intersect': false}

	var ba: Vector2 = a0 - b0
	var q: float = sa.cross(ba) / cross
	var p: float = sb.cross(ba) / cross

	var intersect: bool = p >= 0 && p <= 1 && q >= 0 && q <= 1
	return {'intersect': intersect, 'res': Vector2(p, q)}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	randomize()
	var candidate := Line2D.new()
	for i in range(0, 2):
		var x: float = rand_range(0, max_x)
		var y: float = rand_range(0, max_y)
		candidate.add_point(Vector2(x, y))

	var edges: Array = graph.get_edges()
	var random_edge: Line2D = edges[randi() % edges.size()]

	intersect(candidate, random_edge)


