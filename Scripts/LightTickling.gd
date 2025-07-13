extends PointLight2D

@export var min_energy = 0.85
@export var max_energy = 1.35
@export var min_tam = 0.375
@export var max_tam = 0.475
@export var flicker_speed = 0.01  # Velocidad del parpadeo



var flicker_offset = 0  # Tamaño del movimiento
var flicker_speed_position = 0.5  # Velocidad de movimiento

var fastNoiseLite = FastNoiseLite.new()
var rng = RandomNumberGenerator.new()

func _ready():
	fastNoiseLite.seed = randi()
	fastNoiseLite.noise_type = FastNoiseLite.TYPE_PERLIN
	
	rng.randomize()

func _process(delta):

	# Simular parpadeo de la luz variando la intensidad (energy) con ruido
	energy = lerp(min_energy, max_energy, fastNoiseLite.get_noise_1d(Time.get_ticks_msec() * flicker_speed))
	texture_scale = lerp(min_tam, max_tam, fastNoiseLite.get_noise_1d(Time.get_ticks_msec() * flicker_speed))
	
	# Movimiento leve de la luz
	position.x += fastNoiseLite.get_noise_1d(Time.get_ticks_msec() * flicker_speed_position) * flicker_offset
	position.y += fastNoiseLite.get_noise_1d((Time.get_ticks_msec() + 1000) * flicker_speed_position) * flicker_offset
