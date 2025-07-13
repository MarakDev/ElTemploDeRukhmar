extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var root_node = get_tree().get_root()
	var new_scene_resource = load("res://Scenes/dungeon.tscn") # Load the new level from disk
	var new_scene_node = new_scene_resource.instantiate()
	root_node.add_child(new_scene_node)
	
	$AnimatedSprite2D.play("default")
	await get_tree().create_timer(14).timeout
	
	get_tree().change_scene_to_file("res://Scenes/dungeon.tscn")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
