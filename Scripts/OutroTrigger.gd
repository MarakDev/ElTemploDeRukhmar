extends CharacterBody2D

@export var player_component: Node2D

func _on_area_2d_body_entered(body: Node2D):
	if player_component == body:
		get_tree().change_scene_to_file("res://Scenes/outro.tscn")
