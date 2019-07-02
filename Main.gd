extends Node2D

var max_x: float
var max_y: float
var graph: Graph
var count: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	count = 0
	randomize()
	max_x = get_viewport().size[0]
	max_y = get_viewport().size[1]
	graph = Graph.new()
	add_child(graph)
	create_edges()

func create_edges() -> void:
	# Keeps adding edges until we reach a certain amount
	while graph.get_edges().size() < 6:
		var x1: float = rand_range(0, max_x)
		var y1: float = rand_range(0, max_y)
		var x2: float = rand_range(0, max_x)
		var y2: float = rand_range(0, max_y)

		# Add new edges only if doesn't intersect existing ones
		var inter: bool = false
		for edge in graph.get_edges():
			var line := Line2D.new()
			line.add_point(Vector2(x1, y1))
			line.add_point(Vector2(x2, y2))
			inter = inter or intersect(line, edge).get('intersect')

		if not inter:
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
	# Creates new random line from existing 
	print("starting")
	var candidate := Line2D.new()
	print("getting")
	var edges: Array = graph.get_edges()
	print("got")
	var other_edges: Array = []
	for i in range(0, 2):
		var edge: Line2D = edges[randi() % edges.size()]
		var a: Vector2 = edge.get_point_position(0)
		var b: Vector2 = edge.get_point_position(1)
		other_edges.append(edge)
		edges.erase(edge)
		candidate.add_point(lerp(a, b, randf()))

	# Discard candidate if insersects another
	for edge in edges:
		var i: Dictionary = intersect(candidate, edge)
		if i.get('intersect'):
			print("returning")
			return
	print("after")

	# Splits and add new edge
	for i in range(0, 2):
		var edge: Line2D = other_edges[i]
		graph.remove_edge(edge.get_point_position(0), edge.get_point_position(1))
		graph.add_edge(edge.get_point_position(0), candidate.get_point_position(i))
		graph.add_edge(candidate.get_point_position(i), edge.get_point_position(1))
	graph.add_edge(candidate.get_point_position(0), candidate.get_point_position(1))
