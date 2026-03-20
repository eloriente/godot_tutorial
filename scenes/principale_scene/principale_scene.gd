extends Node2D

@export var levels: Array[PackedScene]
var _current_level: int = 1
var _loaded_level: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_create_level(_current_level)

func _create_level(index_level: int):
	_loaded_level = levels[index_level - 1].instantiate()
	add_child(_loaded_level)
	
	#var characters := get_tree().get_nodes_in_group("characters")
	#characters[0].character_dead.connect(_restart_level)
	var childrens := _loaded_level.get_children()
	for i in childrens.size():
		if childrens[i].is_in_group("characters"):
			childrens[i].character_dead.connect(_restart_level)
			break

func _delete_level():
	_loaded_level.queue_free()
	
func _restart_level():
	_delete_level()
	_create_level.call_deferred(_current_level)
