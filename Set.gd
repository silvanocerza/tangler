extends Node
class_name Set

var _data: Array = []
var _comparator: FuncRef


func _init(comparator: FuncRef):
	_comparator = comparator

func data() -> Array:
	return _data.duplicate(true)

# Pushes new element in element, return true on success
func push(new_element) -> void:
	var contains: bool = false
	for current_element in _data:
		contains = _comparator.call_func(new_element, current_element)
		if contains:
			return
	_data.append(new_element)
	return
