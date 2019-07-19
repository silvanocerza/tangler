extends Node2D

var max_x: float
var max_y: float
var graph: Graph
var count: int
export(int) var starting_edges: int = 6

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
	var edges_added: int = 0
	while edges_added < starting_edges:
		var x1: float = rand_range(0, max_x)
		var y1: float = rand_range(0, max_y)
		var x2: float = rand_range(0, max_x)
		var y2: float = rand_range(0, max_y)

		# Add new edges only if doesn't intersect existing ones
		var inter: bool = false
		for edge in graph.get_edges():
			var line: Array = [Vector2(x1, y1), Vector2(x2, y2)]
			inter = inter or intersect(line, edge).get('intersect')

		if not inter:
			graph.add_edge(Vector2(x1, y1), Vector2(x2, y2))
			edges_added += 1

func intersect(a: Array, b: Array) -> Dictionary:
	var a0: Vector2 = a[0]
	var a1: Vector2 = a[1]
	var b0: Vector2 = b[0]
	var b1: Vector2 = b[1]

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

func create_line_v1() -> void:
	# Creates new random line from existing 
	var candidate: Array = []
	var edges: Array = graph.get_edges()
	var other_edges: Array = []
	for i in range(0, 2):
		var edge: Array = edges[randi() % edges.size()]
		var a: Vector2 = edge[0]
		var b: Vector2 = edge[1]
		other_edges.append(edge)
		edges.erase(edge)
		candidate.append(lerp(a, b, randf()))

	if candidate.size() < 2:
		return

	# Discard candidate if insersects another
	for edge in edges:
		var i: Dictionary = intersect(candidate, edge)
		if i.get('intersect'):
			return

	# Splits and add new edge
	for i in range(0, 2):
		var edge: Array = other_edges[i]
		graph.remove_edge(edge[0], edge[1])
		graph.add_edge(edge[0], candidate[i])
		graph.add_edge(candidate[i], edge[1])
	graph.add_edge(candidate[0], candidate[1])

func create_line_v2() -> void:
	# Creates random line
	var x1: float = rand_range(0, max_x)
	var y1: float = rand_range(0, max_y)
	var x2: float = rand_range(0, max_x)
	var y2: float = rand_range(0, max_y)
	var candidate: Array = [Vector2(x1, y1), Vector2(x2, y2)]

	var intersections: Array = []
	var intersected_edges: Array = []
	var edges: Array = graph.get_edges()
	while intersections.size() != 2:
		# Searches all intersections of candidate line
		for edge in edges:
			var i := intersect(candidate, edge)
			if i['intersect']:
				intersections.append(i['point'])
				intersected_edges.append(edge)

		# Sanity checks
		if intersections.size() < 2:
			return
		elif intersections.size() == 2:
			break

		# Cut the candidate to two random intersections and start over
		candidate[0] = intersections[randi() % intersections.size()]
		candidate[1] = intersections[randi() % intersections.size()]
		intersections.clear()
		intersected_edges.clear()
	
	for i in range(0, 2):
		var edge: Array = intersected_edges[i]
		graph.remove_edge(edge[0], edge[1])
		graph.add_edge(edge[0], intersections[i])
		graph.add_edge(intersections[i], edge[1])
	graph.add_edge(intersections[0], intersections[1])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
#	create_line_v1()
	create_line_v2()
