extends Node
class_name Graph

var edges: Array = []

func get_edges() -> Array:
	return edges

func add_edge(a: Vector2, b: Vector2) -> void:
	var edge := Line2D.new()
	edge.width = 2
	edge.begin_cap_mode = Line2D.LINE_CAP_ROUND
	edge.end_cap_mode = Line2D.LINE_CAP_ROUND
	edge.add_point(a)
	edge.add_point(b)
	edges.append(edge)
	add_child(edge)

func remove_edge(edge: Line2D) -> void:
	var index: int = edges.find(edge)
	edges.remove(index)
	remove_child(edge)

func _process(delta: float):
	# Draw lines here?
	pass