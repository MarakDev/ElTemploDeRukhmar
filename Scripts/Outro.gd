extends Node

var tiempo
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var horas = Tiempo.tiempoTotal / 3600
	var min = (Tiempo.tiempoTotal%3600) / 60
	var seg = Tiempo.tiempoTotal / 60
	
	var horasS = str(horas).pad_zeros(2)
	var minS = str(min).pad_zeros(2)
	var segS = str(seg).pad_zeros(2)
	
	$AnimatedSprite2D.play("default")
	await get_tree().create_timer(12).timeout
	$AnimatedSprite2D.play("tiempo")
	
	await get_tree().create_timer(2).timeout
	$Text.visible = true
	await get_tree().create_timer(2).timeout
	$Text2.text = str(horasS) + ":" + str(minS) + ":" + str(segS)
	$Text2.visible = true
	await get_tree().create_timer(2).timeout
	$Gracias.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
