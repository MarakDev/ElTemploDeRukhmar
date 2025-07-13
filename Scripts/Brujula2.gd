extends CharacterBody2D

@export var player_component: Node2D
@onready var equipado : AudioStreamPlayer2D = $Equipado

func _ready() -> void:
	var anim = $AnimatedSprite2D
	anim.play("idle")

func _on_area_2d_body_entered(body: Node2D):
	if player_component == body:
		$CPUParticles2D.emitting = true
		$AnimatedSprite2D.hide()
		$CollisionShape2D.queue_free()
		$Area2D.queue_free()
		$PointLight2D.queue_free()
		body.tiene_brujula2 = true
		equipado.play()
		await get_tree().create_timer(2).timeout
		queue_free()
