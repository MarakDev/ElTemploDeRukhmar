extends CharacterBody2D

@export var player_component: Node2D
@onready var equipado : AudioStreamPlayer2D = $Equipado
@onready var equipado2 : AudioStreamPlayer2D = $Equipado2

func _ready() -> void:
	var anim = $AnimatedSprite2D
	anim.play("idle")

func _on_area_2d_body_entered(body: Node2D):
	if player_component == body:
		var anim = $AnimatedSprite2D
		anim.play("transformed")
		equipado.play()
		equipado2.play()
		await get_tree().create_timer(4).timeout
		get_tree().change_scene_to_file("res://Scenes/outroS.tscn")
