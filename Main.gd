extends Node2D

var max_x: int
var max_y: int
var graph: Graph

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_x = int(get_viewport().size[0])
	max_y = int(get_viewport().size[1])
	graph = load("res://Graph.gd").new()
	add_child(graph)
	create_triangles()

func create_triangles() -> void:
	randomize()
	var vertices := []
	for i in range(0, 3):
		var x: int = randi() % max_x
		var y: int = randi() % max_y
		vertices.append(Vector2(x, y))

	for i in range(0, len(vertices)):
		graph.add_edge(vertices[i-1], vertices[i])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	pass
