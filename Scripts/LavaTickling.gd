extends PointLight2D


@export var min_energy = 0.9
@export var max_energy = 2.0
@export var flicker_speed = 0.5  # Velocidad del parpadeo

# Variable para la dirección de cambio de intensidad
var increasing := true

func _process(delta):
	
	if increasing:
		energy += flicker_speed * delta
		if energy >= max_energy:
			energy = max_energy
			increasing = false
	else:
		energy -= flicker_speed * delta
		# Cambiar dirección al alcanzar el valor mínimo
		if energy <= min_energy:
			energy = min_energy
			increasing = true
